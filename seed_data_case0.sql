USE [SIGECAP_dev];
GO

/* ====================================================================================
   SEED DATA - CASO 0 (DATOS INICIALES)
   ==================================================================================== */

-- 1. CATÁLOGOS

-- Estados de Inscripción
INSERT INTO cat.estado_inscripcion (codigo, nombre) VALUES 
('INS', 'INSCRITO'),
('APR', 'APROBADO'),
('REP', 'REPROBADO'),
('CAN', 'CANCELADO');

-- Estados de Asistencia
INSERT INTO cat.estado_asistencia (codigo, nombre, peso_valor) VALUES 
('P', 'PRESENTE', 1.0),
('A', 'AUSENTE', 0.0),
('T', 'TARDE', 0.5),
('J', 'JUSTIFICADO', 1.0);

-- Tipos de Evento
INSERT INTO cat.tipo_evento (nombre) VALUES 
('CURSO'),
('TALLER'),
('SEMINARIO'),
('DIPLOMADO');

-- Modalidades
INSERT INTO cat.modalidad (nombre) VALUES 
('PRESENCIAL'),
('VIRTUAL'),
('HIBRIDO');

-- Estados de Evento
INSERT INTO cat.estado_evento (nombre) VALUES 
('BORRADOR'),
('PUBLICADO'),
('EN CURSO'),
('FINALIZADO'),
('CANCELADO');

-- Salones
INSERT INTO cat.salon (nombre, capacidad_maxima) VALUES 
('AULA MAGNA', 50),
('LABORATORIO 1', 20),
('SALA VIRTUAL 1', 100);

-- Recursos (Opcional)
INSERT INTO cat.recurso (nombre, estado) VALUES 
('PROYECTOR', 'DISPONIBLE'),
('LAPTOP', 'DISPONIBLE');

GO

-- 2. PERSONAS Y USUARIOS (CORE & SEC)

-- Admin (Super Usuario)
INSERT INTO core.persona (identificacion, nombres, apellidos, email) 
VALUES ('0801199001234', 'ADMINISTRADOR', 'SISTEMA', 'admin@sigecap.com');

DECLARE @id_persona_admin INT;
SELECT @id_persona_admin = id_persona FROM core.persona WHERE email = 'admin@sigecap.com';

-- Password Hash Placeholder (Hasheado real debería venir del backend)
-- Insertamos usuario admin si no existe
IF NOT EXISTS (SELECT 1 FROM sec.usuario WHERE username = 'admin')
BEGIN
    INSERT INTO sec.usuario (id_persona, username, password_hash, is_locked, created_by)
    VALUES (@id_persona_admin, 'admin', 0x1234567890ABCDEF, 0, 1); 
END

-- Facilitador
INSERT INTO core.persona (identificacion, nombres, apellidos, email) 
VALUES ('0801198500001', 'JUAN', 'PEREZ', 'juan.perez@email.com');

DECLARE @id_persona_facil INT;
SELECT @id_persona_facil = id_persona FROM core.persona WHERE email = 'juan.perez@email.com';

INSERT INTO core.facilitador (id_persona, tipo) 
VALUES (@id_persona_facil, 'INTERNO');

-- Estudiantes (Participantes)
INSERT INTO core.persona (identificacion, nombres, apellidos, email) VALUES 
('0801200000001', 'ANA', 'GARCIA', 'ana.garcia@email.com'),
('0801200000002', 'CARLOS', 'LOPEZ', 'carlos.lopez@email.com'),
('0801200000003', 'MARIA', 'RODRIGUEZ', 'maria.rodriguez@email.com');

GO

-- 3. OPERACIONES - CASO 0 (UN EVENTO ACTIVO)

DECLARE @id_admin INT = (SELECT TOP 1 id_usuario FROM sec.usuario WHERE username = 'admin');

-- Variables para IDs (Búsqueda segura)
DECLARE @id_tipo_curso INT; SELECT @id_tipo_curso = id_tipo_evento FROM cat.tipo_evento WHERE nombre = 'CURSO';
DECLARE @id_mod_presencial INT; SELECT @id_mod_presencial = id_modalidad FROM cat.modalidad WHERE nombre = 'PRESENCIAL';
DECLARE @id_estado_publicado INT; SELECT @id_estado_publicado = id_estado FROM cat.estado_evento WHERE nombre = 'PUBLICADO';
DECLARE @id_salon INT; SELECT @id_salon = id_salon FROM cat.salon WHERE nombre = 'LABORATORIO 1';
DECLARE @id_facilitador INT; SELECT TOP 1 @id_facilitador = id_facilitador FROM core.facilitador;


-- Crear Evento: "Introducción a SQL" (Vigente hoy)
INSERT INTO op.evento (
    codigo_evento, nombre_evento, id_tipo_evento, id_modalidad, id_estado, 
    id_salon, id_facilitador, fecha_inicio, fecha_fin, cupo_maximo, created_by
)
VALUES (
    'EVT-2026-001', 'INTRODUCCION A SQL SERVER', 
    @id_tipo_curso, @id_mod_presencial, @id_estado_publicado,
    @id_salon, @id_facilitador, 
    DATEADD(DAY, -2, GETDATE()), -- Empezó hace 2 días
    DATEADD(DAY, 5, GETDATE()),  -- Termina en 5 días
    20, @id_admin
);

DECLARE @id_evento INT = SCOPE_IDENTITY();

-- Generar Sesiones (Usando el SP)
EXEC op.usp_generar_sesiones_diarias @id_evento, @id_admin;

-- Inscribir Estudiantes
DECLARE @id_estado_ins INT = (SELECT id_estado_inscripcion FROM cat.estado_inscripcion WHERE codigo = 'INS');
DECLARE @id_p1 INT = (SELECT id_persona FROM core.persona WHERE email = 'ana.garcia@email.com');
DECLARE @id_p2 INT = (SELECT id_persona FROM core.persona WHERE email = 'carlos.lopez@email.com');
DECLARE @id_p3 INT = (SELECT id_persona FROM core.persona WHERE email = 'maria.rodriguez@email.com');

INSERT INTO op.inscripcion (id_evento, id_persona, id_estado_inscripcion, created_by) VALUES 
(@id_evento, @id_p1, @id_estado_ins, @id_admin),
(@id_evento, @id_p2, @id_estado_ins, @id_admin),
(@id_evento, @id_p3, @id_estado_ins, @id_admin);

-- Actualizar cupo actual
UPDATE op.evento SET cupo_actual = 3 WHERE id_evento = @id_evento;

-- Crear Evento Futuro (Próximo)
INSERT INTO op.evento (
    codigo_evento, nombre_evento, id_tipo_evento, id_modalidad, id_estado, 
    id_salon, id_facilitador, fecha_inicio, fecha_fin, cupo_maximo, created_by
)
VALUES (
    'EVT-2026-002', 'PROGRAMACION AVANZADA C#', 
    @id_tipo_curso, @id_mod_presencial, @id_estado_publicado,
    @id_salon, @id_facilitador, 
    DATEADD(DAY, 10, GETDATE()), -- Empieza en 10 días
    DATEADD(DAY, 20, GETDATE()), 
    15, @id_admin
);

PRINT 'SEEDED CASE 0 SUCCESSFULLY';
GO
