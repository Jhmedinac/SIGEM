-- =============================================
-- Migration Script: v6_personas_tipo.sql
-- Description: Añade el campo tipo_persona a la tabla core.persona
-- para distinguir entre 'Participante', 'Administrativo' y 'Facilitador'.
-- =============================================

USE SIGE_CAP_dev;
GO

-- 1. Añadir columna tipo_persona a core.persona
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('core.persona') 
    AND name = 'tipo_persona'
)
BEGIN
    ALTER TABLE core.persona
    ADD tipo_persona VARCHAR(50) NOT NULL DEFAULT 'Participante';

    -- 2. Actualizar tipo_persona a 'Administrativo' para aquellos que sean usuarios del sistema
    UPDATE core.persona 
    SET tipo_persona = 'Administrativo'
    WHERE id_persona IN (
        SELECT id_persona FROM sec.usuario WHERE is_deleted = 0
    );

    -- 3. Actualizar tipo_persona a 'Facilitador' para aquellos que sean facilitadores
    UPDATE core.persona 
    SET tipo_persona = 'Facilitador'
    WHERE id_persona IN (
        SELECT id_persona FROM core.facilitador
    );
END
GO
