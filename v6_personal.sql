-- =============================================
-- Migration Script: v6_personal.sql
-- Description: Creación de tabla sec.personal y migración de usuarios existentes.
-- =============================================

USE SIGE_CAP_dev;
GO

-- 1. Crear tabla sec.personal si no existe
IF NOT EXISTS (SELECT * FROM sys.tables WHERE schema_id = SCHEMA_ID('sec') AND name = 'personal')
BEGIN
    CREATE TABLE sec.personal (
        id_personal INT IDENTITY(1,1) PRIMARY KEY,
        identificacion VARCHAR(20) NOT NULL UNIQUE,
        nombres VARCHAR(100) NOT NULL,
        apellidos VARCHAR(100) NOT NULL,
        email VARCHAR(150) NULL,
        telefono VARCHAR(50) NULL,
        is_deleted BIT NOT NULL DEFAULT 0
    );
END
GO

-- 2. Añadir id_personal a sec.usuario
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('sec.usuario') AND name = 'id_personal')
BEGIN
    ALTER TABLE sec.usuario ADD id_personal INT NULL;
    ALTER TABLE sec.usuario ADD CONSTRAINT FK_usuario_personal FOREIGN KEY (id_personal) REFERENCES sec.personal(id_personal);
END
GO

-- 3. Migrar datos de usuarios existentes (core.persona -> sec.personal)
-- Evita duplicados insertando solo si la persona tiene un usuario asociado que aún no tiene id_personal
BEGIN
    -- Declarar variables para el cursor
    DECLARE @id_usuario INT;
    DECLARE @id_persona_old INT;
    DECLARE @ident VARCHAR(20), @nombres VARCHAR(100), @apellidos VARCHAR(100), @email VARCHAR(150), @telefono VARCHAR(50);
    DECLARE @new_id_personal INT;

    DECLARE cur_users CURSOR FOR 
        SELECT u.id_usuario, u.id_persona, p.identificacion, p.nombres, p.apellidos, p.email, p.telefono
        FROM sec.usuario u
        INNER JOIN core.persona p ON u.id_persona = p.id_persona
        WHERE u.id_personal IS NULL;

    OPEN cur_users;
    FETCH NEXT FROM cur_users INTO @id_usuario, @id_persona_old, @ident, @nombres, @apellidos, @email, @telefono;

    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        -- Si la persona ya existe en personal (por identificación), obtener su ID, sino insertarlo
        SELECT @new_id_personal = id_personal FROM sec.personal WHERE identificacion = @ident;

        IF @new_id_personal IS NULL
        BEGIN
            INSERT INTO sec.personal (identificacion, nombres, apellidos, email, telefono)
            VALUES (@ident, @nombres, @apellidos, @email, @telefono);
            SET @new_id_personal = SCOPE_IDENTITY();
        END

        -- Actualizar sec.usuario 
        UPDATE sec.usuario SET id_personal = @new_id_personal WHERE id_usuario = @id_usuario;

        FETCH NEXT FROM cur_users INTO @id_usuario, @id_persona_old, @ident, @nombres, @apellidos, @email, @telefono;
    END

    CLOSE cur_users;  
    DEALLOCATE cur_users;  
END
GO

-- 4. Hacer que id_personal sea NOT NULL si queremos obligarlo (opcional a futuro)
-- Eliminamos / Hacemos deprecado la FK antigua de id_persona (Si deseas conservar el historial puedes omitir este paso, pero la foreign key antigua estorbará)
-- Para mantener la retrocompatibilidad de la base de datos por ahora simplemente dejaremos id_persona NULLable o mantendremos ambas columnas
GO
