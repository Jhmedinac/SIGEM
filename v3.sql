USE [SIGECAP_PROD];
GO

SET XACT_ABORT ON;
BEGIN TRANSACTION;

/* ============================================================
   1. CORRECCIÓN DE CATÁLOGO: ESTADO DE ASISTENCIA
   ============================================================ */
-- Eliminamos la anterior si existe para recrearla bien
DROP VIEW IF EXISTS op.vw_asistencia_resumen;
DROP TABLE IF EXISTS op.asistencia_detalle;
DROP TABLE IF EXISTS cat.estado_asistencia;

CREATE TABLE cat.estado_asistencia (
    id_estado_asistencia INT IDENTITY(1,1) PRIMARY KEY,
    codigo CHAR(1) NOT NULL, 
    nombre VARCHAR(50) NOT NULL,
    peso_valor DECIMAL(3,2) DEFAULT 1.0, 

    is_deleted BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    
    CONSTRAINT UQ_estado_asist_cod UNIQUE(codigo),
    -- CORRECCIÓN 1: Constraint de Rango
    CONSTRAINT CK_estado_asistencia_peso CHECK (peso_valor BETWEEN 0 AND 1)
);

INSERT INTO cat.estado_asistencia (codigo, nombre, peso_valor, created_by) VALUES 
('P', 'PRESENTE', 1.0, 1),
('A', 'AUSENTE', 0.0, 1),
('T', 'TARDANZA', 0.5, 1),
('J', 'JUSTIFICADO', 1.0, 1); -- Ahora Justificado cuenta como asistencia completa

/* ============================================================
   2. FUNCIÓN DE VALIDACIÓN DE FECHAS (Para Constraint)
   ============================================================ */
GO
CREATE FUNCTION op.fn_validar_fecha_sesion(@id_evento INT, @fecha_sesion DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT = 0;
    
    IF EXISTS (
        SELECT 1 FROM op.evento 
        WHERE id_evento = @id_evento 
        AND @fecha_sesion BETWEEN CAST(fecha_inicio AS DATE) AND CAST(fecha_fin AS DATE)
    )
        SET @resultado = 1;

    RETURN @resultado;
END
GO

/* ============================================================
   3. TABLA: SESIONES DEL EVENTO (Blindada)
   ============================================================ */
DROP TABLE IF EXISTS op.evento_sesion;

CREATE TABLE op.evento_sesion (
    id_sesion INT IDENTITY(1,1) PRIMARY KEY,
    id_evento INT NOT NULL,
    
    nombre_sesion VARCHAR(100) NULL,
    fecha_sesion DATE NOT NULL,
    hora_inicio TIME(0) NOT NULL,
    hora_fin TIME(0) NOT NULL,
    
    id_facilitador INT NULL,
    id_salon INT NULL,

    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    is_deleted BIT DEFAULT 0,

    CONSTRAINT FK_sesion_evento FOREIGN KEY (id_evento) REFERENCES op.evento(id_evento),
    CONSTRAINT CK_sesion_horas CHECK (hora_fin > hora_inicio),
    
    -- CORRECCIÓN 2: Validación de Rango de Fechas (Requiere la función creada arriba)
    CONSTRAINT CK_sesion_dentro_evento CHECK (op.fn_validar_fecha_sesion(id_evento, fecha_sesion) = 1),

    -- CORRECCIÓN 3: Unique Constraint necesaria para la FK Compuesta más adelante
    CONSTRAINT UQ_sesion_evento UNIQUE (id_sesion, id_evento)
);

-- CORRECCIÓN 4: Índices faltantes para evitar Table Scans
CREATE INDEX IX_sesion_facilitador ON op.evento_sesion(id_facilitador);
CREATE INDEX IX_sesion_salon ON op.evento_sesion(id_salon);
CREATE NONCLUSTERED INDEX IX_sesion_evento_active ON op.evento_sesion(id_evento, fecha_sesion) WHERE is_deleted = 0;


/* ============================================================
   4. PREPARACIÓN DE INSCRIPCIÓN (Para FK Compuesta)
   ============================================================ */
-- Necesitamos asegurar que op.inscripcion tenga un índice único (id_inscripcion, id_evento)
-- para poder referenciarlo.
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_inscripcion_compuesta' AND object_id = OBJECT_ID('op.inscripcion'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UQ_inscripcion_compuesta 
    ON op.inscripcion(id_inscripcion, id_evento);
END
GO

/* ============================================================
   5. TABLA: DETALLE DE ASISTENCIA (Integridad de Diamante)
   ============================================================ */
CREATE TABLE op.asistencia_detalle (
    id_asistencia INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Campos Clave
    id_sesion INT NOT NULL,
    id_inscripcion INT NOT NULL,
    id_evento INT NOT NULL, -- CORRECCIÓN 5: Campo redundante necesario para integridad estricta
    
    id_estado_asistencia INT NOT NULL,
    hora_marcado DATETIME2(0) DEFAULT SYSDATETIME(),
    observacion VARCHAR(200) NULL,

    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    updated_at DATETIME2(3) NULL, 
    updated_by INT NULL,

    -- FK Normales
    CONSTRAINT FK_asist_estado FOREIGN KEY (id_estado_asistencia) REFERENCES cat.estado_asistencia(id_estado_asistencia),

    -- CORRECCIÓN 6: CLAVES FORÁNEAS COMPUESTAS (SOLUCIÓN ENTERPRISE)
    -- Esto garantiza que la SESIÓN pertenezca al evento
    CONSTRAINT FK_asist_sesion_compuesta 
        FOREIGN KEY (id_sesion, id_evento) 
        REFERENCES op.evento_sesion(id_sesion, id_evento),

    -- Esto garantiza que la INSCRIPCIÓN pertenezca al MISMO evento
    CONSTRAINT FK_asist_inscripcion_compuesta 
        FOREIGN KEY (id_inscripcion, id_evento) 
        REFERENCES op.inscripcion(id_inscripcion, id_evento),
    
    CONSTRAINT UQ_asistencia_unica UNIQUE(id_sesion, id_inscripcion)
);

-- CORRECCIÓN 7: Índices optimizados para reportes masivos
CREATE NONCLUSTERED INDEX IX_asist_sesion_insc ON op.asistencia_detalle(id_sesion, id_inscripcion) INCLUDE (id_estado_asistencia);


/* ============================================================
   6. SP CORREGIDO: GENERAR SESIONES
   ============================================================ */
GO
CREATE OR ALTER PROCEDURE op.usp_generar_sesiones_diarias
    @id_evento INT,
    @usuario_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- CORRECCIÓN 8: Manejo de errores transaccionales

    BEGIN TRANSACTION;

    DECLARE @f_inicio DATE, @f_fin DATE, @h_inicio TIME, @h_fin TIME;
    
    SELECT @f_inicio = CAST(fecha_inicio AS DATE), 
           @f_fin = CAST(fecha_fin AS DATE),
           @h_inicio = CAST(fecha_inicio AS TIME),
           @h_fin = CAST(fecha_fin AS TIME)
    FROM op.evento WHERE id_evento = @id_evento;

    -- CTE Recursivo con protección
    ;WITH Fechas AS (
        SELECT @f_inicio AS fecha
        UNION ALL
        SELECT DATEADD(DAY, 1, fecha)
        FROM Fechas
        WHERE fecha < @f_fin
    )
    INSERT INTO op.evento_sesion (id_evento, fecha_sesion, hora_inicio, hora_fin, created_by)
    SELECT @id_evento, fecha, @h_inicio, @h_fin, @usuario_id
    FROM Fechas
    WHERE 
        -- CORRECCIÓN 9: Cálculo de día independiente del idioma (Lunes=0 ... Domingo=6)
        (DATEPART(WEEKDAY, fecha) + @@DATEFIRST - 1) % 7 NOT IN (5, 6) -- 5=Sábado, 6=Domingo
        
        -- CORRECCIÓN 10: Idempotencia (Evitar duplicados)
        AND NOT EXISTS (
            SELECT 1 FROM op.evento_sesion es 
            WHERE es.id_evento = @id_evento AND es.fecha_sesion = Fechas.fecha
        )
    OPTION (MAXRECURSION 1000); -- CORRECCIÓN 11: Límite de recursión

    COMMIT TRANSACTION;
END
GO

/* ============================================================
   7. VISTA CORREGIDA: MATEMÁTICA DINÁMICA
   ============================================================ */
GO
CREATE OR ALTER VIEW op.vw_asistencia_resumen
AS
SELECT 
    i.id_inscripcion,
    i.id_evento,
    
    -- Métricas Base
    COUNT(s.id_sesion) AS total_sesiones_programadas,
    
    -- CORRECCIÓN 12: Uso de ISNULL(peso_valor, 0) en lugar de hardcode
    SUM(ISNULL(ea.peso_valor, 0)) AS puntaje_asistencia,
    
    -- Cálculo de porcentaje final
    CAST(
        CASE WHEN COUNT(s.id_sesion) = 0 THEN 0 
        ELSE (SUM(ISNULL(ea.peso_valor, 0)) / COUNT(s.id_sesion)) * 100 
        END 
    AS DECIMAL(5,2)) AS porcentaje_cumplimiento

FROM op.inscripcion i
JOIN op.evento_sesion s ON i.id_evento = s.id_evento AND s.is_deleted = 0
LEFT JOIN op.asistencia_detalle ad ON s.id_sesion = ad.id_sesion AND i.id_inscripcion = ad.id_inscripcion
LEFT JOIN cat.estado_asistencia ea ON ad.id_estado_asistencia = ea.id_estado_asistencia
WHERE i.is_deleted = 0
GROUP BY i.id_inscripcion, i.id_evento;
GO

COMMIT;
PRINT 'Módulo de Asistencia v5.0 (Platinum) Implementado Correctamente.';