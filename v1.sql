/* ============================================================
   SISTEMA: SIGECAP v1.0 
   DESCRIPCIÓN: Script de Objetos (DDL) optimizado y blindado
   CAMBIOS v3.0: 
     - Índices FK totales
     - Password VARBINARY
     - Estado Inscripción normalizado
     - DENY DELETE explícito
     - Constraint Cupo Máximo
   ============================================================ */

USE [SIGECAP_DEV] ; -- 
GO

SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
GO

/* ============================================================
   1. ESQUEMAS
   ============================================================ */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'core') EXEC('CREATE SCHEMA core');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'cat')  EXEC('CREATE SCHEMA cat');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'sec')  EXEC('CREATE SCHEMA sec');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'op')   EXEC('CREATE SCHEMA op'); -- Operaciones/Transaccional
GO

/* ============================================================
   2. CATÁLOGOS (Tablas Maestras)
   ============================================================ */

-- 2.1 Estado Inscripción (NUEVO: Reemplaza al CHECK constraint)
CREATE TABLE cat.estado_inscripcion (
    id_estado_inscripcion INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL, -- INSCRITO, CONFIRMADO, ASISTIO...
    nombre VARCHAR(50) NOT NULL,
    is_deleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT UQ_estado_inscripcion_cod UNIQUE(codigo)
);

-- 2.2 Tipo Evento
CREATE TABLE cat.tipo_evento (
    id_tipo_evento INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    is_deleted BIT NOT NULL DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL
);

-- 2.3 Modalidad
CREATE TABLE cat.modalidad (
    id_modalidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    requiere_salon BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL
);

-- 2.4 Estado Evento
CREATE TABLE cat.estado_evento (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    es_final BIT DEFAULT 0,
    is_deleted BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL
);

-- 2.5 Salon
CREATE TABLE cat.salon (
    id_salon INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    capacidad_maxima INT NOT NULL CHECK (capacidad_maxima > 0),
    is_deleted BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL
);

-- 2.6 Recurso
CREATE TABLE cat.recurso (
    id_recurso INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado VARCHAR(20) DEFAULT 'DISPONIBLE',
    is_deleted BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL
);

/* ============================================================
   3. CORE (Personas y Seguridad)
   ============================================================ */

CREATE TABLE core.persona (
    id_persona INT IDENTITY(1,1) PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    updated_at DATETIME2(3) NULL,
    updated_by INT NULL,
    is_deleted BIT DEFAULT 0
);
-- Índice en Email ya cubierto por UNIQUE constraint, pero agregamos uno non-clustered si se busca mucho
CREATE NONCLUSTERED INDEX IX_persona_busqueda ON core.persona(apellidos, nombres);

CREATE TABLE sec.usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    
    -- MEJORA 4: VARBINARY para Hash
    password_hash VARBINARY(64) NOT NULL, 
    
    is_locked BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    is_deleted BIT DEFAULT 0,

    CONSTRAINT FK_usuario_persona FOREIGN KEY (id_persona) REFERENCES core.persona(id_persona)
);
-- MEJORA 1: Índice en FK
CREATE NONCLUSTERED INDEX IX_usuario_persona ON sec.usuario(id_persona);

CREATE TABLE core.facilitador (
    id_facilitador INT IDENTITY(1,1) PRIMARY KEY,
    id_persona INT NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('INTERNO','EXTERNO')),
    is_deleted BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,

    CONSTRAINT FK_facilitador_persona FOREIGN KEY (id_persona) REFERENCES core.persona(id_persona)
);
-- MEJORA 1: Índice en FK
CREATE NONCLUSTERED INDEX IX_facilitador_persona ON core.facilitador(id_persona);

/* ============================================================
   4. OPERACIONES (Eventos)
   ============================================================ */

CREATE TABLE op.evento (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,
    codigo_evento VARCHAR(30) NOT NULL UNIQUE,
    nombre_evento VARCHAR(200) NOT NULL,
    
    id_tipo_evento INT NOT NULL,
    id_modalidad INT NOT NULL,
    id_estado INT NOT NULL,
    id_salon INT NULL,
    id_facilitador INT NULL,

    fecha_inicio DATETIME2(0) NOT NULL,
    fecha_fin DATETIME2(0) NOT NULL,
    
    cupo_maximo INT NOT NULL CHECK (cupo_maximo > 0),
    cupo_actual INT NOT NULL DEFAULT 0,

    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    updated_at DATETIME2(3) NULL,
    updated_by INT NULL,
    is_deleted BIT DEFAULT 0,

    -- MEJORA 3: Constraint de Integridad de Cupo
    CONSTRAINT CK_cupo_valido CHECK (cupo_actual <= cupo_maximo),
    CONSTRAINT CK_fechas_validas CHECK (fecha_fin >= fecha_inicio),

    CONSTRAINT FK_evento_tipo FOREIGN KEY (id_tipo_evento) REFERENCES cat.tipo_evento(id_tipo_evento),
    CONSTRAINT FK_evento_modal FOREIGN KEY (id_modalidad) REFERENCES cat.modalidad(id_modalidad),
    CONSTRAINT FK_evento_estado FOREIGN KEY (id_estado) REFERENCES cat.estado_evento(id_estado),
    CONSTRAINT FK_evento_salon FOREIGN KEY (id_salon) REFERENCES cat.salon(id_salon),
    CONSTRAINT FK_evento_facil FOREIGN KEY (id_facilitador) REFERENCES core.facilitador(id_facilitador)
);

-- MEJORA 1: Índices en TODAS las FKs de Evento
CREATE NONCLUSTERED INDEX IX_evento_tipo ON op.evento(id_tipo_evento);
CREATE NONCLUSTERED INDEX IX_evento_modal ON op.evento(id_modalidad);
CREATE NONCLUSTERED INDEX IX_evento_estado ON op.evento(id_estado); -- Crítico para dashboards
CREATE NONCLUSTERED INDEX IX_evento_salon ON op.evento(id_salon);
CREATE NONCLUSTERED INDEX IX_evento_facil ON op.evento(id_facilitador);
CREATE NONCLUSTERED INDEX IX_evento_fechas ON op.evento(fecha_inicio, fecha_fin); -- Crítico para disponibilidad

/* ============================================================
   5. HISTORIALES Y DETALLES
   ============================================================ */

CREATE TABLE op.evento_estado_historial (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_evento INT NOT NULL,
    id_estado_ant INT NULL,
    id_estado_new INT NOT NULL,
    fecha_cambio DATETIME2(3) DEFAULT SYSDATETIME(),
    usuario_id INT NOT NULL,

    CONSTRAINT FK_hist_evento FOREIGN KEY (id_evento) REFERENCES op.evento(id_evento),
    CONSTRAINT FK_hist_new FOREIGN KEY (id_estado_new) REFERENCES cat.estado_evento(id_estado)
);
-- MEJORA 7: Índices faltantes en historial
CREATE NONCLUSTERED INDEX IX_hist_evento ON op.evento_estado_historial(id_evento);
CREATE NONCLUSTERED INDEX IX_hist_estado_new ON op.evento_estado_historial(id_estado_new);
CREATE NONCLUSTERED INDEX IX_hist_fecha ON op.evento_estado_historial(fecha_cambio); -- Para reportes cronológicos

CREATE TABLE op.evento_recurso (
    id_asignacion INT IDENTITY(1,1) PRIMARY KEY,
    id_evento INT NOT NULL,
    id_recurso INT NOT NULL,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    is_deleted BIT DEFAULT 0,

    CONSTRAINT FK_erecurso_evento FOREIGN KEY (id_evento) REFERENCES op.evento(id_evento),
    CONSTRAINT FK_erecurso_recurso FOREIGN KEY (id_recurso) REFERENCES cat.recurso(id_recurso)
);
-- MEJORA 1: Índices FK
CREATE NONCLUSTERED INDEX IX_erecurso_evento ON op.evento_recurso(id_evento);
CREATE NONCLUSTERED INDEX IX_erecurso_recurso ON op.evento_recurso(id_recurso);

/* ============================================================
   6. INSCRIPCIONES Y EVALUACIONES (Core Business)
   ============================================================ */

CREATE TABLE op.inscripcion (
    id_inscripcion INT IDENTITY(1,1) PRIMARY KEY,
    id_evento INT NOT NULL,
    id_persona INT NOT NULL,
    
    -- MEJORA 2: Referencia a Catálogo en lugar de String/Check
    id_estado_inscripcion INT NOT NULL, 
    
    nota_final DECIMAL(4,2) NULL,
    asistencia BIT DEFAULT 0,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    is_deleted BIT DEFAULT 0,

    CONSTRAINT UQ_inscripcion_unica UNIQUE(id_evento, id_persona),
    CONSTRAINT FK_insc_evento FOREIGN KEY (id_evento) REFERENCES op.evento(id_evento),
    CONSTRAINT FK_insc_persona FOREIGN KEY (id_persona) REFERENCES core.persona(id_persona),
    CONSTRAINT FK_insc_estado FOREIGN KEY (id_estado_inscripcion) REFERENCES cat.estado_inscripcion(id_estado_inscripcion)
);
-- MEJORA 1: Índices FK
CREATE NONCLUSTERED INDEX IX_insc_evento ON op.inscripcion(id_evento);
CREATE NONCLUSTERED INDEX IX_insc_persona ON op.inscripcion(id_persona);
CREATE NONCLUSTERED INDEX IX_insc_estado ON op.inscripcion(id_estado_inscripcion);

CREATE TABLE op.evaluacion (
    id_evaluacion INT IDENTITY(1,1) PRIMARY KEY,
    id_inscripcion INT NOT NULL,
    calificacion DECIMAL(4,2) NOT NULL CHECK (calificacion BETWEEN 0 AND 10),
    comentario NVARCHAR(500) NULL,
    created_at DATETIME2(3) DEFAULT SYSDATETIME(),
    created_by INT NOT NULL,
    is_deleted BIT DEFAULT 0,

    CONSTRAINT FK_eval_insc FOREIGN KEY (id_inscripcion) REFERENCES op.inscripcion(id_inscripcion)
);
CREATE NONCLUSTERED INDEX IX_eval_insc ON op.evaluacion(id_inscripcion);

/* ============================================================
   7. SEGURIDAD AVANZADA
   ============================================================ */

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_role_write')
    CREATE ROLE app_role_write;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_role_read')
    CREATE ROLE app_role_read;
GO

-- Permisos de Lectura
GRANT SELECT ON SCHEMA::core TO app_role_read;
GRANT SELECT ON SCHEMA::cat  TO app_role_read;
GRANT SELECT ON SCHEMA::op   TO app_role_read;
GRANT SELECT ON SCHEMA::sec  TO app_role_read;

-- Permisos de Escritura (INSERT/UPDATE)
GRANT INSERT, UPDATE ON SCHEMA::core TO app_role_write;
GRANT INSERT, UPDATE ON SCHEMA::cat  TO app_role_write;
GRANT INSERT, UPDATE ON SCHEMA::op   TO app_role_write;
GRANT INSERT, UPDATE ON SCHEMA::sec  TO app_role_write;

-- MEJORA 6: DENY DELETE EXPLÍCITO (Obliga a usar Soft Delete "is_deleted")
DENY DELETE ON SCHEMA::core TO app_role_write;
DENY DELETE ON SCHEMA::cat  TO app_role_write;
DENY DELETE ON SCHEMA::op   TO app_role_write;
DENY DELETE ON SCHEMA::sec  TO app_role_write;

COMMIT;
GO

PRINT 'SCRIPT V3.0 (GOLDEN MASTER) EJECUTADO - TODAS LAS REGLAS APLICADAS';