-- =============================================
-- Migration Script: v5_roles.sql
-- Description: Creación de tabla de roles y asociación con usuarios.
-- =============================================

USE SIGE_CAP_dev;
GO

-- 1. Crear tabla sec.rol
IF NOT EXISTS (SELECT * FROM sys.tables WHERE schema_id = SCHEMA_ID('sec') AND name = 'rol')
BEGIN
    CREATE TABLE sec.rol (
        id_rol INT PRIMARY KEY NOT NULL,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        descripcion VARCHAR(100) NULL
    );
END
GO

-- 2. Insertar registros iniciales de roles
IF NOT EXISTS (SELECT 1 FROM sec.rol WHERE id_rol = 1)
BEGIN
    INSERT INTO sec.rol (id_rol, nombre, descripcion)
    VALUES 
        (1, 'Super Administrador', 'Acceso total al sistema'),
        (2, 'Administrador Jefe Departamento', 'Acceso a la gestión de su departamento'),
        (3, 'Técnico', 'Acceso a funciones operativas');
END
GO

-- 3. Modificar tabla sec.usuario (Añadir FK id_rol si no existe)
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('sec.usuario') 
    AND name = 'id_rol'
)
BEGIN
    ALTER TABLE sec.usuario
    ADD id_rol INT NULL;

    ALTER TABLE sec.usuario
    ADD CONSTRAINT FK_usuario_rol FOREIGN KEY (id_rol) REFERENCES sec.rol(id_rol);

    -- Opcionalmente: Asignar a todos los usuarios actuales (si existen) el rol de Super Admin (1) por defecto
    UPDATE sec.usuario SET id_rol = 1 WHERE id_rol IS NULL;
END
GO
