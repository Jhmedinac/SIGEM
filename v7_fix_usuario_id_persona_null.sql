USE SIGE_CAP_dev;
GO

-- Permitir que id_persona sea NULL en sec.usuario, ya que ahora usamos id_personal para los administradores.
ALTER TABLE sec.usuario ALTER COLUMN id_persona INT NULL;
GO
