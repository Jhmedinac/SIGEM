USE [master]
GO
/****** Object:  Database [SIGECAP_DEV]    Script Date: 16/2/2026 11:47:09 ******/
CREATE DATABASE [SIGECAP_DEV]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SIGECAP_DEV', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL_DEV\MSSQL\DATA\SIGECAP_DEV.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SIGECAP_DEV_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL_DEV\MSSQL\DATA\SIGECAP_DEV_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [SIGECAP_DEV] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SIGECAP_DEV].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SIGECAP_DEV] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET ARITHABORT OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SIGECAP_DEV] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SIGECAP_DEV] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SIGECAP_DEV] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SIGECAP_DEV] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET RECOVERY FULL 
GO
ALTER DATABASE [SIGECAP_DEV] SET  MULTI_USER 
GO
ALTER DATABASE [SIGECAP_DEV] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SIGECAP_DEV] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SIGECAP_DEV] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SIGECAP_DEV] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SIGECAP_DEV] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SIGECAP_DEV] SET QUERY_STORE = OFF
GO
USE [SIGECAP_DEV]
GO
/****** Object:  User [tsc_simeg_dev]    Script Date: 16/2/2026 11:47:09 ******/
CREATE USER [tsc_simeg_dev] FOR LOGIN [tsc_simeg_dev] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [tsc_sigecap_dev]    Script Date: 16/2/2026 11:47:09 ******/
CREATE USER [tsc_sigecap_dev] FOR LOGIN [tsc_sigecap_dev] WITH DEFAULT_SCHEMA=[bd]
GO
ALTER ROLE [db_owner] ADD MEMBER [tsc_sigecap_dev]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [tsc_sigecap_dev]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [tsc_sigecap_dev]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [tsc_sigecap_dev]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [tsc_sigecap_dev]
GO
ALTER ROLE [db_datareader] ADD MEMBER [tsc_sigecap_dev]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [tsc_sigecap_dev]
GO
/****** Object:  Schema [bd]    Script Date: 16/2/2026 11:47:09 ******/
CREATE SCHEMA [bd]
GO
/****** Object:  Schema [cat]    Script Date: 16/2/2026 11:47:09 ******/
CREATE SCHEMA [cat]
GO
/****** Object:  Table [bd].[persona]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[persona](
	[id_persona] [int] IDENTITY(1,1) NOT NULL,
	[codigo_empleado] [varchar](20) NULL,
	[identificacion] [varchar](20) NOT NULL,
	[primernombre] [varchar](100) NOT NULL,
	[segundonombre] [varchar](100) NULL,
	[primerapellido] [varchar](100) NOT NULL,
	[segundoapellido] [varchar](100) NULL,
	[email] [varchar](100) NOT NULL,
	[telefono] [varchar](20) NULL,
	[id_direccion] [int] NOT NULL,
	[id_departamento] [int] NOT NULL,
	[id_cargo] [int] NULL,
	[fecha_ingreso] [date] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_modificacion] [datetime] NULL,
	[id_genero] [int] NULL,
 CONSTRAINT [PK__persona__228148B0D43B30DF] PRIMARY KEY CLUSTERED 
(
	[id_persona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__persona__AB6E61646DF542BA] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__persona__C196DEC751198281] UNIQUE NONCLUSTERED 
(
	[identificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__persona__CDEF1DDFED733808] UNIQUE NONCLUSTERED 
(
	[codigo_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[facilitador]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[facilitador](
	[id_facilitador] [int] IDENTITY(1,1) NOT NULL,
	[id_persona] [int] NULL,
	[tipo_facilitador] [varchar](20) NOT NULL,
	[nombres] [varchar](100) NOT NULL,
	[apellidos] [varchar](100) NOT NULL,
	[email] [varchar](100) NULL,
	[telefono] [varchar](20) NULL,
	[institucion] [varchar](500) NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_modificacion] [datetime] NULL,
	[especialidad] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_facilitador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[salon](
	[id_salon] [int] IDENTITY(1,1) NOT NULL,
	[nombre_salon] [varchar](100) NOT NULL,
	[ubicacion] [varchar](200) NULL,
	[capacidad_maxima] [int] NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_salon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[evento](
	[id_evento] [int] IDENTITY(1,1) NOT NULL,
	[codigo_evento] [varchar](30) NOT NULL,
	[nombre_evento] [varchar](200) NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[objetivo] [nvarchar](max) NULL,
	[id_tipo_evento] [int] NOT NULL,
	[id_modalidad] [int] NOT NULL,
	[id_coordinador] [int] NOT NULL,
	[id_estado] [int] NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[fecha_fin] [date] NOT NULL,
	[hora_inicio] [time](7) NOT NULL,
	[hora_fin] [time](7) NOT NULL,
	[duracion_horas] [decimal](5, 2) NULL,
	[año] [int] NOT NULL,
	[id_salon] [int] NULL,
	[cupo_maximo] [int] NULL,
	[cupo_actual] [int] NULL,
	[motivo] [nvarchar](max) NULL,
	[observaciones] [nvarchar](max) NULL,
	[fecha_solicitud] [date] NOT NULL,
	[fecha_aprobacion] [date] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_modificacion] [datetime] NULL,
	[id_facilitador] [int] NULL,
	[id_gerencia_solicitante] [varchar](50) NULL,
	[id_solicitante] [int] NULL,
	[anio] [int] NULL,
	[estado] [varchar](50) NULL,
	[usuario_creacion] [varchar](50) NULL,
	[usuario_modificacion] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[modalidad]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[modalidad](
	[id_modalidad] [int] IDENTITY(1,1) NOT NULL,
	[nombre_modalidad] [varchar](50) NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[requiere_salon] [bit] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_modalidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_modalidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[tipo_evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[tipo_evento](
	[id_tipo_evento] [int] IDENTITY(1,1) NOT NULL,
	[nombre_tipo] [varchar](500) NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[requiere_evaluacion] [bit] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[estado_solicitud]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[estado_solicitud](
	[id_estado] [int] IDENTITY(1,1) NOT NULL,
	[nombre_estado] [varchar](50) NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[es_estado_final] [bit] NULL,
	[orden_secuencial] [int] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_eventos_completo]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2. Creamos la vista definitiva con TODAS las columnas que Python necesita
CREATE VIEW [dbo].[vw_eventos_completo] AS
SELECT 
    -- Datos principales
    e.id_evento,
    e.codigo_evento,
    e.nombre_evento,
    e.descripcion,
    e.objetivo,
    e.fecha_inicio,
    e.fecha_fin,
    e.hora_inicio,
    e.hora_fin,
    e.cupo_maximo,
    e.cupo_actual,
    (e.cupo_maximo - e.cupo_actual) AS cupos_disponibles,
    e.activo,

    -- IDs para el modo EDICIÓN (Python necesita estos números para rellenar los Dropdowns)
    e.id_estado,
    e.id_modalidad,
    e.id_tipo_evento,
    e.id_facilitador,
    e.id_salon,
    e.id_coordinador,
    e.id_gerencia_solicitante,
    e.id_solicitante,

    -- Textos descriptivos para la TABLA (Lo que ve el usuario)
    es.nombre_estado AS estado_desc,
    m.nombre_modalidad AS modalidad_desc,
    te.nombre_tipo AS tipo_evento_desc,
    ISNULL(s.nombre_salon, 'VIRTUAL / POR DEFINIR') AS nombre_salon,

    -- Lógica para el nombre del Facilitador (Interno vs Externo)
    CASE 
        WHEN f.tipo_facilitador = 'INTERNO' THEN (p_fac.primernombre + ' ' + p_fac.primerapellido)
        ELSE (ISNULL(f.nombres, '') + ' ' + ISNULL(f.apellidos, ''))
    END AS facilitador_nombre

FROM bd.evento e
-- Usamos LEFT JOIN para que no desaparezca el evento si falta algún dato
LEFT JOIN bd.estado_solicitud es ON e.id_estado = es.id_estado
LEFT JOIN bd.modalidad m ON e.id_modalidad = m.id_modalidad
LEFT JOIN bd.tipo_evento te ON e.id_tipo_evento = te.id_tipo_evento
LEFT JOIN bd.salon s ON e.id_salon = s.id_salon
-- Joins para Facilitador
LEFT JOIN bd.facilitador f ON e.id_facilitador = f.id_facilitador
LEFT JOIN bd.persona p_fac ON f.id_persona = p_fac.id_persona;
GO
/****** Object:  Table [bd].[coordinador]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[coordinador](
	[id_coordinador] [int] IDENTITY(1,1) NOT NULL,
	[id_persona] [int] NOT NULL,
	[fecha_asignacion] [date] NOT NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_coordinador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[id_persona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [bd].[vw_coordinadores_completo]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bd].[vw_coordinadores_completo]
AS
SELECT
    c.id_coordinador,
    c.id_persona,
    p.primernombre,
    p.segundonombre,
    p.primerapellido,
    p.segundoapellido,
    (p.primernombre + ' ' +
     ISNULL(p.segundonombre + ' ', '') +
     p.primerapellido + ' ' +
     ISNULL(p.segundoapellido, '')
    ) AS nombre_completo,
    c.activo,
    c.fecha_asignacion
FROM bd.coordinador c
INNER JOIN bd.persona p ON c.id_persona = p.id_persona;
GO
/****** Object:  View [bd].[View_Departamentos]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bd].[View_Departamentos]
AS
SELECT
    Dependencia            AS Cod_Direccion,
    Codigo_Direccion       AS Cod_Departamento,
    Descripcion_Direccion  AS Desc_Departamento,
    Dependencia,
    Activa,
    Tipo
FROM SIMEG_DEV.dbo.Direccion_TSC
WHERE Dependencia > 0;
GO
/****** Object:  Table [bd].[cargo]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[cargo](
	[id_cargo] [int] IDENTITY(1,1) NOT NULL,
	[nombre_cargo] [varchar](100) NOT NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_personas_index]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_personas_index]
AS
SELECT 
    p.id_persona,
    p.codigo_empleado,
    p.identificacion,
    -- Concatenamos el nombre completo para mostrarlo bonito en la tabla
    (p.primernombre + ' ' + ISNULL(p.segundonombre, '') + ' ' + p.primerapellido + ' ' + ISNULL(p.segundoapellido, '')) AS nombre_completo,
    
    -- Traemos los nombres reales de cargo y departamento
    ISNULL(c.nombre_cargo, '---') AS nombre_cargo,
    ISNULL(d.Desc_Departamento, '---') AS nombre_departamento,
    
    -- Campos crudos necesarios para el botón "Editar"
    p.primernombre,
    p.segundonombre,
    p.primerapellido,
    p.segundoapellido,
    p.email,
    p.telefono,
    p.id_direccion,
    p.id_departamento,
    p.id_cargo,
    p.activo

FROM bd.persona p
LEFT JOIN bd.cargo c ON p.id_cargo = c.id_cargo
-- Hacemos JOIN con la vista de departamentos usando la columna que vimos en su imagen
LEFT JOIN bd.View_Departamentos d ON p.id_departamento = d.Cod_Departamento;
GO
/****** Object:  Table [bd].[tipo_recurso]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[tipo_recurso](
	[id_tipo_recurso] [int] IDENTITY(1,1) NOT NULL,
	[nombre_tipo] [varchar](500) NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo_recurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[recurso]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[recurso](
	[id_recurso] [int] IDENTITY(1,1) NOT NULL,
	[id_tipo_recurso] [int] NOT NULL,
	[codigo_recurso] [varchar](20) NULL,
	[nombre_recurso] [varchar](500) NOT NULL,
	[descripcion] [nvarchar](max) NULL,
	[cantidad_disponible] [int] NULL,
	[estado_recurso] [varchar](20) NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_recurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo_recurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[evento_recurso]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[evento_recurso](
	[id_evento_recurso] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[id_recurso] [int] NOT NULL,
	[cantidad_solicitada] [int] NOT NULL,
	[fecha_asignacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evento_recurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [uk_evento_recurso] UNIQUE NONCLUSTERED 
(
	[id_evento] ASC,
	[id_recurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [bd].[vw_recursos_evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bd].[vw_recursos_evento] AS
SELECT 
    er.id_evento_recurso,
    e.codigo_evento,
    e.nombre_evento,
    tr.nombre_tipo AS tipo_recurso,
    r.nombre_recurso,
    r.codigo_recurso,
    er.cantidad_solicitada,
    r.cantidad_disponible,
    r.estado_recurso,
    er.fecha_asignacion
FROM evento_recurso er
INNER JOIN evento e ON er.id_evento = e.id_evento
INNER JOIN recurso r ON er.id_recurso = r.id_recurso
INNER JOIN tipo_recurso tr ON r.id_tipo_recurso = tr.id_tipo_recurso;
GO
/****** Object:  Table [bd].[participante]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[participante](
	[id_participante] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[id_persona] [int] NOT NULL,
	[fecha_inscripcion] [datetime] NULL,
	[estado_participacion] [varchar](20) NULL,
	[fecha_confirmacion] [datetime] NULL,
	[asistencia] [bit] NULL,
	[porcentaje_asistencia] [decimal](5, 2) NULL,
	[observaciones] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_participante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [uk_evento_persona] UNIQUE NONCLUSTERED 
(
	[id_evento] ASC,
	[id_persona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[evaluacion]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[evaluacion](
	[id_evaluacion] [int] IDENTITY(1,1) NOT NULL,
	[id_participante] [int] NOT NULL,
	[calificacion_contenido] [decimal](3, 2) NULL,
	[calificacion_facilitador] [decimal](3, 2) NULL,
	[calificacion_organizacion] [decimal](3, 2) NULL,
	[calificacion_general] [decimal](3, 2) NULL,
	[comentarios] [nvarchar](max) NULL,
	[sugerencias] [nvarchar](max) NULL,
	[aplicabilidad_trabajo] [varchar](10) NULL,
	[recomendaria] [bit] NULL,
	[fecha_evaluacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evaluacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [uk_evaluacion_participante] UNIQUE NONCLUSTERED 
(
	[id_participante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [bd].[vw_evaluaciones_detalle]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bd].[vw_evaluaciones_detalle] AS
SELECT 
    ev.id_evaluacion,
    e.codigo_evento,
    e.nombre_evento,
    CONCAT(p.primernombre, ' ', p.primerapellido) AS participante,
    ev.calificacion_contenido,
    ev.calificacion_facilitador,
    ev.calificacion_organizacion,
    ev.calificacion_general,
    ev.aplicabilidad_trabajo,
    ev.recomendaria,
    ev.comentarios,
    ev.sugerencias,
    ev.fecha_evaluacion
FROM evaluacion ev
INNER JOIN participante pa ON ev.id_participante = pa.id_participante
INNER JOIN evento e ON pa.id_evento = e.id_evento
INNER JOIN persona p ON pa.id_persona = p.id_persona;
GO
/****** Object:  Table [bd].[direcciones]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[direcciones](
	[id_direccion] [int] NOT NULL,
	[nombre_direccion] [varchar](200) NOT NULL,
	[activa] [bit] NULL,
	[tipo] [varchar](50) NULL,
	[fecha_sincronizacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_direccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[departamentos]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[departamentos](
	[id_departamento] [int] NOT NULL,
	[nombre_departamento] [varchar](200) NOT NULL,
	[id_direccion] [int] NOT NULL,
	[activa] [bit] NULL,
	[tipo] [varchar](50) NULL,
	[fecha_sincronizacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_departamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [bd].[vista_participantes_evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2. Arreglamos la vista de PARTICIPANTES (Para que no falle al inscribir)
CREATE   VIEW [bd].[vista_participantes_evento]
AS
SELECT 
    e.id_evento,
    e.codigo_evento,
    e.nombre_evento,
	part.id_participante,
    per.id_persona,
    per.primernombre,
    per.primerapellido,

    -- Nombre completo del participante
    CONCAT(
        per.primernombre, ' ',
        ISNULL(per.segundonombre, ''), ' ',
        per.primerapellido, ' ',
        ISNULL(per.segundoapellido, '')
    ) AS participante,
    per.email,
    -- Dirección y Departamento (desde TABLAS espejo)
    dir.nombre_direccion      AS direccion,
    dep.nombre_departamento   AS departamento,
    c.nombre_cargo            AS cargo,
    part.estado_participacion,
    part.asistencia,
    part.fecha_inscripcion
FROM participante part
INNER JOIN evento e 
    ON part.id_evento = e.id_evento
INNER JOIN persona per 
    ON part.id_persona = per.id_persona
LEFT JOIN direcciones dir 
    ON per.id_direccion = dir.id_direccion
LEFT JOIN departamentos dep 
    ON per.id_departamento = dep.id_departamento
LEFT JOIN cargo c 
    ON per.id_cargo = c.id_cargo;
GO
/****** Object:  View [bd].[View_Direcciones]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bd].[View_Direcciones]
AS
SELECT
    Codigo_Direccion      AS Cod_Direccion,
    Descripcion_Direccion AS Desc_Direccion,
    Dependencia,
    Activa,
    Tipo
FROM SIMEG_DEV.dbo.Direccion_TSC
WHERE 
    (Dependencia IS NULL OR Dependencia = 0)
    AND Activa IN (0, 1);
GO
/****** Object:  Table [bd].[equipo]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[equipo](
	[id_equipo] [int] IDENTITY(1,1) NOT NULL,
	[codigo_equipo] [varchar](20) NULL,
	[nombre_equipo] [varchar](100) NOT NULL,
	[tipo_equipo] [varchar](50) NULL,
	[marca] [varchar](50) NULL,
	[modelo] [varchar](50) NULL,
	[num_serie] [varchar](50) NULL,
	[num_inventario] [varchar](50) NULL,
	[num_correlativo] [varchar](50) NULL,
	[estado_equipo] [varchar](20) NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_equipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo_equipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[num_correlativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[num_serie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[num_inventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[evento_equipo]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[evento_equipo](
	[id_evento_equipo] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[id_equipo] [int] NOT NULL,
	[fecha_asignacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evento_equipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [uk_evento_equipo] UNIQUE NONCLUSTERED 
(
	[id_evento] ASC,
	[id_equipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[evento_facilitador]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[evento_facilitador](
	[id_evento_facilitador] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[id_facilitador] [int] NOT NULL,
	[rol_facilitador] [varchar](50) NULL,
	[fecha_asignacion] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evento_facilitador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [uk_evento_facilitador] UNIQUE NONCLUSTERED 
(
	[id_evento] ASC,
	[id_facilitador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[genero]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[genero](
	[id_genero] [int] IDENTITY(1,1) NOT NULL,
	[nombre_genero] [varchar](50) NOT NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_genero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_genero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[historial_estado_evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[historial_estado_evento](
	[id_historial] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[id_estado_anterior] [int] NULL,
	[id_estado_nuevo] [int] NOT NULL,
	[usuario_cambio] [varchar](100) NULL,
	[fecha_cambio] [datetime] NULL,
	[motivo_cambio] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_historial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[inscripcion]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[inscripcion](
	[id_inscripcion] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[id_persona] [int] NOT NULL,
	[fecha_inscripcion] [datetime] NULL,
	[asistio] [bit] NULL,
	[nota_final] [decimal](5, 2) NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_inscripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[rol]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[rol](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[nombre_rol] [nvarchar](100) NOT NULL,
	[activo] [bit] NOT NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[usuario_creacion] [int] NOT NULL,
	[fecha_modificacion] [datetime] NULL,
	[usuario_modificacion] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[sector]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[sector](
	[CODI_SECTOR] [int] NOT NULL,
	[nombre_sector] [nvarchar](100) NOT NULL,
	[siglas] [nvarchar](12) NULL,
	[clasificador] [char](1) NULL,
	[codigo_acceso] [int] NULL,
	[tiempo_maximo] [int] NULL,
	[tiempo_aviso] [int] NULL,
	[acceso] [bit] NOT NULL,
	[correo] [nvarchar](150) NULL,
	[cco_correo] [nvarchar](150) NULL,
	[activo] [bit] NOT NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[usuario_creacion] [int] NOT NULL,
	[fecha_modificacion] [datetime] NULL,
	[usuario_modificacion] [int] NULL,
 CONSTRAINT [PK__sector__F9185B4AA700A573] PRIMARY KEY CLUSTERED 
(
	[CODI_SECTOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_sector_nombre] UNIQUE NONCLUSTERED 
(
	[nombre_sector] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_sector_siglas] UNIQUE NONCLUSTERED 
(
	[siglas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[usuario]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[usuario](
	[id_usuario] [int] IDENTITY(1,1) NOT NULL,
	[id_persona] [int] NOT NULL,
	[id_rol] [int] NOT NULL,
	[username] [nvarchar](100) NOT NULL,
	[password_hash] [nvarchar](255) NOT NULL,
	[activo] [bit] NOT NULL,
	[bloqueado] [bit] NOT NULL,
	[principal] [bit] NOT NULL,
	[finalizar] [bit] NOT NULL,
	[intentos_fallidos] [int] NOT NULL,
	[fecha_bloqueo] [datetime] NULL,
	[ultimo_login] [datetime] NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[usuario_creacion] [int] NOT NULL,
	[fecha_modificacion] [datetime] NULL,
	[usuario_modificacion] [int] NULL,
	[fecha_baja] [datetime] NULL,
	[usuario_baja] [int] NULL,
	[ip_creacion] [varchar](45) NULL,
	[ip_modificacion] [varchar](45) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bd].[usuario_auditoria]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[usuario_auditoria](
	[id_auditoria] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [int] NOT NULL,
	[accion] [varchar](10) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[usuario_accion] [int] NOT NULL,
	[ip] [varchar](45) NULL,
	[detalle] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_auditoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [bd].[usuario_sector]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bd].[usuario_sector](
	[id_usuario] [int] NOT NULL,
	[CODI_SECTOR] [int] NOT NULL,
	[activo] [bit] NOT NULL,
	[fecha_asignacion] [datetime] NOT NULL,
	[fecha_fin] [datetime] NULL,
	[usuario_asignacion] [int] NOT NULL,
	[usuario_fin] [int] NULL,
	[observaciones] [nvarchar](250) NULL,
 CONSTRAINT [PK_usuario_sector] PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC,
	[CODI_SECTOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_cargo_nombre]    Script Date: 16/2/2026 11:47:09 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_cargo_nombre] ON [bd].[cargo]
(
	[nombre_cargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_anio]    Script Date: 16/2/2026 11:47:09 ******/
CREATE NONCLUSTERED INDEX [idx_anio] ON [bd].[evento]
(
	[año] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_fecha_evento]    Script Date: 16/2/2026 11:47:09 ******/
CREATE NONCLUSTERED INDEX [idx_fecha_evento] ON [bd].[evento]
(
	[fecha_inicio] ASC,
	[fecha_fin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_rol_nombre]    Script Date: 16/2/2026 11:47:09 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_rol_nombre] ON [bd].[rol]
(
	[nombre_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_usuario_sector_sector]    Script Date: 16/2/2026 11:47:09 ******/
CREATE NONCLUSTERED INDEX [IX_usuario_sector_sector] ON [bd].[usuario_sector]
(
	[CODI_SECTOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_usuario_sector_usuario]    Script Date: 16/2/2026 11:47:09 ******/
CREATE NONCLUSTERED INDEX [IX_usuario_sector_usuario] ON [bd].[usuario_sector]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bd].[cargo] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[cargo] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[coordinador] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[coordinador] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[departamentos] ADD  DEFAULT (getdate()) FOR [fecha_sincronizacion]
GO
ALTER TABLE [bd].[direcciones] ADD  DEFAULT (getdate()) FOR [fecha_sincronizacion]
GO
ALTER TABLE [bd].[equipo] ADD  DEFAULT ('DISPONIBLE') FOR [estado_equipo]
GO
ALTER TABLE [bd].[equipo] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[equipo] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[estado_solicitud] ADD  DEFAULT ((0)) FOR [es_estado_final]
GO
ALTER TABLE [bd].[estado_solicitud] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[estado_solicitud] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[evaluacion] ADD  DEFAULT (getdate()) FOR [fecha_evaluacion]
GO
ALTER TABLE [bd].[evento] ADD  DEFAULT ((0)) FOR [cupo_actual]
GO
ALTER TABLE [bd].[evento] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[evento] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[evento] ADD  DEFAULT (getdate()) FOR [fecha_modificacion]
GO
ALTER TABLE [bd].[evento] ADD  DEFAULT ('PENDIENTE') FOR [estado]
GO
ALTER TABLE [bd].[evento_equipo] ADD  DEFAULT (getdate()) FOR [fecha_asignacion]
GO
ALTER TABLE [bd].[evento_recurso] ADD  DEFAULT ((1)) FOR [cantidad_solicitada]
GO
ALTER TABLE [bd].[evento_recurso] ADD  DEFAULT (getdate()) FOR [fecha_asignacion]
GO
ALTER TABLE [bd].[facilitador] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[facilitador] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[facilitador] ADD  DEFAULT (getdate()) FOR [fecha_modificacion]
GO
ALTER TABLE [bd].[genero] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[genero] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[historial_estado_evento] ADD  DEFAULT (getdate()) FOR [fecha_cambio]
GO
ALTER TABLE [bd].[inscripcion] ADD  DEFAULT (getdate()) FOR [fecha_inscripcion]
GO
ALTER TABLE [bd].[inscripcion] ADD  DEFAULT ((0)) FOR [asistio]
GO
ALTER TABLE [bd].[inscripcion] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[modalidad] ADD  DEFAULT ((1)) FOR [requiere_salon]
GO
ALTER TABLE [bd].[modalidad] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[modalidad] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[participante] ADD  DEFAULT (getdate()) FOR [fecha_inscripcion]
GO
ALTER TABLE [bd].[participante] ADD  DEFAULT ('INSCRITO') FOR [estado_participacion]
GO
ALTER TABLE [bd].[participante] ADD  DEFAULT ((0)) FOR [asistencia]
GO
ALTER TABLE [bd].[persona] ADD  CONSTRAINT [DF__persona__activo__131DCD43]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[persona] ADD  CONSTRAINT [DF__persona__fecha_c__1411F17C]  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[persona] ADD  CONSTRAINT [DF__persona__fecha_m__150615B5]  DEFAULT (getdate()) FOR [fecha_modificacion]
GO
ALTER TABLE [bd].[recurso] ADD  DEFAULT ((1)) FOR [cantidad_disponible]
GO
ALTER TABLE [bd].[recurso] ADD  DEFAULT ('DISPONIBLE') FOR [estado_recurso]
GO
ALTER TABLE [bd].[recurso] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[recurso] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[rol] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[rol] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[salon] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[salon] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[sector] ADD  CONSTRAINT [DF__sector__acceso__4944D3CA]  DEFAULT ((1)) FOR [acceso]
GO
ALTER TABLE [bd].[sector] ADD  CONSTRAINT [DF__sector__activo__4A38F803]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[sector] ADD  CONSTRAINT [DF__sector__fecha_cr__4B2D1C3C]  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[tipo_evento] ADD  DEFAULT ((1)) FOR [requiere_evaluacion]
GO
ALTER TABLE [bd].[tipo_evento] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[tipo_evento] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[tipo_recurso] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[usuario] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[usuario] ADD  DEFAULT ((0)) FOR [bloqueado]
GO
ALTER TABLE [bd].[usuario] ADD  DEFAULT ((0)) FOR [principal]
GO
ALTER TABLE [bd].[usuario] ADD  DEFAULT ((0)) FOR [finalizar]
GO
ALTER TABLE [bd].[usuario] ADD  DEFAULT ((0)) FOR [intentos_fallidos]
GO
ALTER TABLE [bd].[usuario] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [bd].[usuario_auditoria] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [bd].[usuario_sector] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [bd].[usuario_sector] ADD  DEFAULT (getdate()) FOR [fecha_asignacion]
GO
ALTER TABLE [bd].[coordinador]  WITH NOCHECK ADD  CONSTRAINT [FK__coordinad__id_pe__24485945] FOREIGN KEY([id_persona])
REFERENCES [bd].[persona] ([id_persona])
GO
ALTER TABLE [bd].[coordinador] CHECK CONSTRAINT [FK__coordinad__id_pe__24485945]
GO
ALTER TABLE [bd].[departamentos]  WITH NOCHECK ADD  CONSTRAINT [FK_departamentos_direcciones] FOREIGN KEY([id_direccion])
REFERENCES [bd].[direcciones] ([id_direccion])
GO
ALTER TABLE [bd].[departamentos] CHECK CONSTRAINT [FK_departamentos_direcciones]
GO
ALTER TABLE [bd].[evaluacion]  WITH NOCHECK ADD FOREIGN KEY([id_participante])
REFERENCES [bd].[participante] ([id_participante])
ON DELETE CASCADE
GO
ALTER TABLE [bd].[evento]  WITH NOCHECK ADD FOREIGN KEY([id_estado])
REFERENCES [bd].[estado_solicitud] ([id_estado])
GO
ALTER TABLE [bd].[evento]  WITH NOCHECK ADD FOREIGN KEY([id_modalidad])
REFERENCES [bd].[modalidad] ([id_modalidad])
GO
ALTER TABLE [bd].[evento]  WITH NOCHECK ADD FOREIGN KEY([id_salon])
REFERENCES [bd].[salon] ([id_salon])
GO
ALTER TABLE [bd].[evento]  WITH NOCHECK ADD FOREIGN KEY([id_tipo_evento])
REFERENCES [bd].[tipo_evento] ([id_tipo_evento])
GO
ALTER TABLE [bd].[evento]  WITH NOCHECK ADD  CONSTRAINT [FK_Evento_Persona_Coordinador] FOREIGN KEY([id_coordinador])
REFERENCES [bd].[persona] ([id_persona])
GO
ALTER TABLE [bd].[evento] CHECK CONSTRAINT [FK_Evento_Persona_Coordinador]
GO
ALTER TABLE [bd].[evento_equipo]  WITH NOCHECK ADD FOREIGN KEY([id_equipo])
REFERENCES [bd].[equipo] ([id_equipo])
GO
ALTER TABLE [bd].[evento_equipo]  WITH NOCHECK ADD FOREIGN KEY([id_evento])
REFERENCES [bd].[evento] ([id_evento])
ON DELETE CASCADE
GO
ALTER TABLE [bd].[evento_facilitador]  WITH NOCHECK ADD FOREIGN KEY([id_evento])
REFERENCES [bd].[evento] ([id_evento])
ON DELETE CASCADE
GO
ALTER TABLE [bd].[evento_facilitador]  WITH NOCHECK ADD FOREIGN KEY([id_facilitador])
REFERENCES [bd].[facilitador] ([id_facilitador])
GO
ALTER TABLE [bd].[evento_recurso]  WITH NOCHECK ADD FOREIGN KEY([id_evento])
REFERENCES [bd].[evento] ([id_evento])
ON DELETE CASCADE
GO
ALTER TABLE [bd].[evento_recurso]  WITH NOCHECK ADD FOREIGN KEY([id_recurso])
REFERENCES [bd].[recurso] ([id_recurso])
GO
ALTER TABLE [bd].[facilitador]  WITH NOCHECK ADD  CONSTRAINT [FK__facilitad__id_pe__1E8F7FEF] FOREIGN KEY([id_persona])
REFERENCES [bd].[persona] ([id_persona])
GO
ALTER TABLE [bd].[facilitador] CHECK CONSTRAINT [FK__facilitad__id_pe__1E8F7FEF]
GO
ALTER TABLE [bd].[historial_estado_evento]  WITH NOCHECK ADD FOREIGN KEY([id_estado_anterior])
REFERENCES [bd].[estado_solicitud] ([id_estado])
GO
ALTER TABLE [bd].[historial_estado_evento]  WITH NOCHECK ADD FOREIGN KEY([id_estado_nuevo])
REFERENCES [bd].[estado_solicitud] ([id_estado])
GO
ALTER TABLE [bd].[historial_estado_evento]  WITH NOCHECK ADD FOREIGN KEY([id_evento])
REFERENCES [bd].[evento] ([id_evento])
ON DELETE CASCADE
GO
ALTER TABLE [bd].[inscripcion]  WITH NOCHECK ADD  CONSTRAINT [FK_inscripcion_evento] FOREIGN KEY([id_evento])
REFERENCES [bd].[evento] ([id_evento])
GO
ALTER TABLE [bd].[inscripcion] CHECK CONSTRAINT [FK_inscripcion_evento]
GO
ALTER TABLE [bd].[inscripcion]  WITH NOCHECK ADD  CONSTRAINT [FK_inscripcion_persona] FOREIGN KEY([id_persona])
REFERENCES [bd].[persona] ([id_persona])
GO
ALTER TABLE [bd].[inscripcion] CHECK CONSTRAINT [FK_inscripcion_persona]
GO
ALTER TABLE [bd].[participante]  WITH NOCHECK ADD FOREIGN KEY([id_evento])
REFERENCES [bd].[evento] ([id_evento])
ON DELETE CASCADE
GO
ALTER TABLE [bd].[participante]  WITH NOCHECK ADD  CONSTRAINT [FK__participa__id_pe__6339AFF7] FOREIGN KEY([id_persona])
REFERENCES [bd].[persona] ([id_persona])
GO
ALTER TABLE [bd].[participante] CHECK CONSTRAINT [FK__participa__id_pe__6339AFF7]
GO
ALTER TABLE [bd].[persona]  WITH NOCHECK ADD  CONSTRAINT [FK_persona_cargo] FOREIGN KEY([id_cargo])
REFERENCES [bd].[cargo] ([id_cargo])
GO
ALTER TABLE [bd].[persona] CHECK CONSTRAINT [FK_persona_cargo]
GO
ALTER TABLE [bd].[persona]  WITH NOCHECK ADD  CONSTRAINT [FK_persona_departamentos] FOREIGN KEY([id_departamento])
REFERENCES [bd].[departamentos] ([id_departamento])
GO
ALTER TABLE [bd].[persona] CHECK CONSTRAINT [FK_persona_departamentos]
GO
ALTER TABLE [bd].[persona]  WITH NOCHECK ADD  CONSTRAINT [FK_persona_direcciones] FOREIGN KEY([id_direccion])
REFERENCES [bd].[direcciones] ([id_direccion])
GO
ALTER TABLE [bd].[persona] CHECK CONSTRAINT [FK_persona_direcciones]
GO
ALTER TABLE [bd].[recurso]  WITH NOCHECK ADD FOREIGN KEY([id_tipo_recurso])
REFERENCES [bd].[tipo_recurso] ([id_tipo_recurso])
GO
ALTER TABLE [bd].[usuario_sector]  WITH NOCHECK ADD  CONSTRAINT [FK_usuario_sector_sector] FOREIGN KEY([CODI_SECTOR])
REFERENCES [bd].[sector] ([CODI_SECTOR])
GO
ALTER TABLE [bd].[usuario_sector] CHECK CONSTRAINT [FK_usuario_sector_sector]
GO
ALTER TABLE [bd].[usuario_sector]  WITH NOCHECK ADD  CONSTRAINT [FK_usuario_sector_usuario] FOREIGN KEY([id_usuario])
REFERENCES [bd].[usuario] ([id_usuario])
GO
ALTER TABLE [bd].[usuario_sector] CHECK CONSTRAINT [FK_usuario_sector_usuario]
GO
ALTER TABLE [bd].[equipo]  WITH NOCHECK ADD CHECK  (([estado_equipo]='INACTIVO' OR [estado_equipo]='MANTENIMIENTO' OR [estado_equipo]='EN_USO' OR [estado_equipo]='DISPONIBLE'))
GO
ALTER TABLE [bd].[evaluacion]  WITH NOCHECK ADD CHECK  (([aplicabilidad_trabajo]='BAJA' OR [aplicabilidad_trabajo]='MEDIA' OR [aplicabilidad_trabajo]='ALTA'))
GO
ALTER TABLE [bd].[evaluacion]  WITH NOCHECK ADD CHECK  (([calificacion_contenido]>=(0) AND [calificacion_contenido]<=(10)))
GO
ALTER TABLE [bd].[evaluacion]  WITH NOCHECK ADD CHECK  (([calificacion_facilitador]>=(0) AND [calificacion_facilitador]<=(10)))
GO
ALTER TABLE [bd].[evaluacion]  WITH NOCHECK ADD CHECK  (([calificacion_organizacion]>=(0) AND [calificacion_organizacion]<=(10)))
GO
ALTER TABLE [bd].[evaluacion]  WITH NOCHECK ADD CHECK  (([calificacion_general]>=(0) AND [calificacion_general]<=(10)))
GO
ALTER TABLE [bd].[facilitador]  WITH NOCHECK ADD CHECK  (([tipo_facilitador]='EXTERNO' OR [tipo_facilitador]='INTERNO'))
GO
ALTER TABLE [bd].[participante]  WITH NOCHECK ADD CHECK  (([estado_participacion]='CANCELADO' OR [estado_participacion]='NO_ASISTIO' OR [estado_participacion]='ASISTIO' OR [estado_participacion]='CONFIRMADO' OR [estado_participacion]='INSCRITO'))
GO
ALTER TABLE [bd].[recurso]  WITH NOCHECK ADD CHECK  (([estado_recurso]='INACTIVO' OR [estado_recurso]='MANTENIMIENTO' OR [estado_recurso]='EN_USO' OR [estado_recurso]='DISPONIBLE'))
GO
/****** Object:  StoredProcedure [bd].[sp_anular_reserva_salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_anular_reserva_salon]
    @id_reserva INT
AS
BEGIN
    UPDATE reserva_salon
    SET estado = 'ANULADO'
    WHERE id_reserva = @id_reserva;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_asignar_facilitador]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_asignar_facilitador]
    @id_evento INT,
    @id_facilitador INT,
    @rol_facilitador VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        INSERT INTO evento_facilitador (id_evento, id_facilitador, rol_facilitador, fecha_asignacion)
        VALUES (@id_evento, @id_facilitador, @rol_facilitador, GETDATE());
        
        SELECT 'Facilitador asignado exitosamente' AS mensaje;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [bd].[sp_asignar_recurso]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_asignar_recurso]
    @id_evento INT,
    @id_recurso INT,
    @cantidad_solicitada INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @cantidad_disponible INT;
        
        -- Verificar disponibilidad
        SELECT @cantidad_disponible = cantidad_disponible 
        FROM recurso WHERE id_recurso = @id_recurso;
        
        IF @cantidad_disponible < @cantidad_solicitada
        BEGIN
            RAISERROR('No hay suficiente cantidad disponible del recurso', 16, 1);
            RETURN;
        END
        
        -- Asignar recurso
        INSERT INTO evento_recurso (id_evento, id_recurso, cantidad_solicitada)
        VALUES (@id_evento, @id_recurso, @cantidad_solicitada);
        
        COMMIT TRANSACTION;
        
        SELECT 'Recurso asignado exitosamente' AS mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [bd].[sp_cambiar_estado_evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [bd].[sp_cambiar_estado_evento]
    @id_evento INT,
    @nuevo_estado VARCHAR(50) -- Recibe 'APROBADO' o 'CANCELADO' desde Python
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Buscamos el ID numérico que corresponde al texto (ej. APROBADO -> 2)
    DECLARE @id_nuevo_estado INT;
    
    SELECT TOP 1 @id_nuevo_estado = id_estado 
    FROM bd.estado_solicitud 
    WHERE nombre_estado = @nuevo_estado;

    -- Validación de seguridad
    IF @id_nuevo_estado IS NOT NULL
    BEGIN
        -- 2. Actualizamos AMBAS columnas en la tabla evento
        -- Actualizamos id_estado (para que la vista funcione)
        -- Actualizamos estado (para que la columna de texto vieja también esté al día)
        UPDATE bd.evento
        SET 
            id_estado = @id_nuevo_estado,
            estado = @nuevo_estado,
            fecha_modificacion = GETDATE()
        WHERE id_evento = @id_evento;
    END
END
GO
/****** Object:  StoredProcedure [bd].[sp_consultar_disponibilidad_salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_consultar_disponibilidad_salon]
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        s.id_salon,
        s.nombre_salon,
        s.ubicacion,
        s.capacidad_maxima,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM evento e 
                WHERE e.id_salon = s.id_salon 
                AND e.activo = 1
                AND (
                    (e.fecha_inicio BETWEEN @fecha_inicio AND @fecha_fin) OR
                    (e.fecha_fin BETWEEN @fecha_inicio AND @fecha_fin) OR
                    (@fecha_inicio BETWEEN e.fecha_inicio AND e.fecha_fin)
                )
            ) THEN 'OCUPADO'
            ELSE 'DISPONIBLE'
        END AS estado_disponibilidad
    FROM salon s
    WHERE s.activo = 1
    ORDER BY s.nombre_salon;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_consultar_eventos_por_fecha]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_consultar_eventos_por_fecha]
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM vw_eventos_completo
    WHERE fecha_inicio >= @fecha_inicio AND fecha_fin <= @fecha_fin
    ORDER BY fecha_inicio, hora_inicio;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_consultar_historial_estado]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_consultar_historial_estado]
    @id_evento INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        h.id_historial,
        ea.nombre_estado AS estado_anterior,
        en.nombre_estado AS estado_nuevo,
        h.usuario_cambio,
        h.fecha_cambio,
        h.motivo_cambio
    FROM historial_estado_evento h
    LEFT JOIN estado_solicitud ea ON h.id_estado_anterior = ea.id_estado
    INNER JOIN estado_solicitud en ON h.id_estado_nuevo = en.id_estado
    WHERE h.id_evento = @id_evento
    ORDER BY h.fecha_cambio DESC;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_crear_evento]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [bd].[sp_crear_evento]
    @codigo_evento VARCHAR(50),
    @nombre_evento VARCHAR(255),
    @descripcion VARCHAR(MAX),
    @objetivo VARCHAR(MAX),
    @id_tipo_evento INT,
    @id_modalidad INT,
    @id_coordinador INT,
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @hora_inicio TIME,
    @hora_fin TIME,
    @anio INT,
    @id_salon INT = NULL,
    @cupo_maximo INT,
    @usuario_registro VARCHAR(50), 
    @id_evento INT = NULL,
    @id_facilitador INT = NULL,
    @id_gerencia_solicitante VARCHAR(50) = NULL,
    @id_solicitante INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Obtener dinámicamente el ID del estado 'PENDIENTE'
    -- Esto evita fallos si el ID es 1, 5 o 100 en su base de datos.
    DECLARE @id_estado_inicial INT;
    SELECT TOP 1 @id_estado_inicial = id_estado FROM bd.estado_solicitud WHERE nombre_estado = 'PENDIENTE';

    -- Si no existe, usamos el primer ID que encontremos como fallback
    IF @id_estado_inicial IS NULL 
        SELECT TOP 1 @id_estado_inicial = id_estado FROM bd.estado_solicitud;

    IF @id_evento IS NULL OR @id_evento = 0
    BEGIN
        -- INSERTAR NUEVO REGISTRO
        INSERT INTO bd.evento (
            -- Campos Obligatorios según su imagen
            codigo_evento, 
            nombre_evento, 
            id_tipo_evento, 
            id_modalidad, 
            id_coordinador, 
            id_estado,          -- Obligatorio
            fecha_inicio, 
            fecha_fin, 
            hora_inicio, 
            hora_fin, 
            [año],              -- Obligatorio (El original)
            cupo_maximo, 
            cupo_actual,        -- Obligatorio (Faltaba este)
            fecha_solicitud,    -- Obligatorio
            activo,
            
            -- Campos Nullables (Opcionales)
            descripcion, 
            objetivo, 
            id_salon, 
            usuario_creacion, 
            fecha_creacion, 
            id_facilitador, 
            id_gerencia_solicitante, 
            id_solicitante,
            anio                -- El duplicado (Nullable)
        )
        VALUES (
            @codigo_evento, 
            @nombre_evento, 
            @id_tipo_evento, 
            @id_modalidad, 
            @id_coordinador, 
            @id_estado_inicial, -- ID buscado arriba
            @fecha_inicio, 
            @fecha_fin, 
            @hora_inicio, 
            @hora_fin, 
            @anio,              -- Insertamos en [año]
            @cupo_maximo, 
            0,                  -- cupo_actual inicia en 0
            GETDATE(),          -- fecha_solicitud
            1,                  -- activo
            
            @descripcion, 
            @objetivo, 
            @id_salon, 
            @usuario_registro, 
            GETDATE(), 
            @id_facilitador, 
            @id_gerencia_solicitante, 
            @id_solicitante,
            @anio               -- Insertamos también en anio por si acaso
        );
    END
    ELSE
    BEGIN
        -- ACTUALIZAR REGISTRO EXISTENTE
        UPDATE bd.evento
        SET 
            codigo_evento = @codigo_evento,
            nombre_evento = @nombre_evento,
            descripcion = @descripcion,
            objetivo = @objetivo,
            id_tipo_evento = @id_tipo_evento,
            id_modalidad = @id_modalidad,
            id_coordinador = @id_coordinador,
            fecha_inicio = @fecha_inicio,
            fecha_fin = @fecha_fin,
            hora_inicio = @hora_inicio,
            hora_fin = @hora_fin,
            [año] = @anio,
            anio = @anio, -- Actualizamos ambos
            id_salon = @id_salon,
            cupo_maximo = @cupo_maximo,
            -- cupo_actual NO se actualiza aquí, eso es operativo
            id_facilitador = @id_facilitador,
            id_gerencia_solicitante = @id_gerencia_solicitante,
            id_solicitante = @id_solicitante,
            fecha_modificacion = GETDATE(),
            usuario_modificacion = @usuario_registro
        WHERE id_evento = @id_evento;
    END
END

GO
/****** Object:  StoredProcedure [bd].[sp_dashboard_estadisticas]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_dashboard_estadisticas]
    @p_anio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Query 1: Eventos por estado
    SELECT es.nombre_estado, COUNT(*) AS total_eventos
    FROM evento e
    INNER JOIN estado_solicitud es ON e.id_estado = es.id_estado
    WHERE e.año = @p_anio
    GROUP BY es.nombre_estado;

    -- Query 2: Resumen global
    SELECT 
        COUNT(DISTINCT part.id_persona) AS total_participantes_unicos,
        COUNT(*) AS total_inscripciones,
        SUM(CASE WHEN part.asistencia = 1 THEN 1 ELSE 0 END) AS total_asistencias
    FROM participante part
    INNER JOIN evento e ON part.id_evento = e.id_evento
    WHERE e.año = @p_anio;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_estadisticas_eventos_anio]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_estadisticas_eventos_anio]
    @anio INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        te.nombre_tipo AS tipo_evento,
        COUNT(e.id_evento) AS total_eventos,
        SUM(e.cupo_actual) AS total_participantes,
        AVG(CAST(e.cupo_actual AS FLOAT)) AS promedio_participantes,
        SUM(e.duracion_horas) AS total_horas_capacitacion
    FROM evento e
    INNER JOIN tipo_evento te ON e.id_tipo_evento = te.id_tipo_evento
    WHERE e.año = @anio AND e.activo = 1
    GROUP BY te.nombre_tipo
    ORDER BY total_eventos DESC;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_inscribir_participante]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_inscribir_participante]
    @p_id_evento INT,
    @p_id_persona INT,
    @p_mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @v_cupo_actual INT;
    DECLARE @v_cupo_maximo INT;
    DECLARE @v_existe INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si ya existe
        SELECT @v_existe = COUNT(*) 
        FROM participante 
        WHERE id_evento = @p_id_evento AND id_persona = @p_id_persona;

        IF @v_existe > 0
        BEGIN
            SET @p_mensaje = 'El participante ya está inscrito.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar cupos
        SELECT @v_cupo_actual = cupo_actual, @v_cupo_maximo = cupo_maximo
        FROM evento WHERE id_evento = @p_id_evento;

        IF @v_cupo_actual >= @v_cupo_maximo
        BEGIN
            SET @p_mensaje = 'No hay cupos disponibles.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inscribir
        INSERT INTO participante (id_evento, id_persona, estado_participacion)
        VALUES (@p_id_evento, @p_id_persona, 'INSCRITO');

        -- Actualizar contador
        UPDATE evento SET cupo_actual = cupo_actual + 1 WHERE id_evento = @p_id_evento;

        SET @p_mensaje = 'Participante inscrito exitosamente';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @p_mensaje = 'Error SQL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
/****** Object:  StoredProcedure [bd].[sp_insertar_reserva_salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_insertar_reserva_salon]
    @id_salon INT,
    @id_evento INT = NULL,
    @fecha DATE,
    @hora_inicio TIME,
    @hora_fin TIME,
    @motivo VARCHAR(200),
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de choque
    IF EXISTS (
        SELECT 1
        FROM reserva_salon
        WHERE id_salon = @id_salon
          AND fecha = @fecha
          AND estado = 'RESERVADO'
          AND (
                @hora_inicio < hora_fin
                AND @hora_fin > hora_inicio
              )
    )
    BEGIN
        RAISERROR ('El salón ya está reservado en ese horario.', 16, 1);
        RETURN;
    END

    INSERT INTO reserva_salon (
        id_salon, id_evento, fecha,
        hora_inicio, hora_fin,
        motivo, id_usuario
    )
    VALUES (
        @id_salon, @id_evento, @fecha,
        @hora_inicio, @hora_fin,
        @motivo, @id_usuario
    );
END;
GO
/****** Object:  StoredProcedure [bd].[sp_listar_reservas_salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_listar_reservas_salon]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        r.id_reserva,
        s.nombre_salon,
        r.fecha,
        r.hora_inicio,
        r.hora_fin,
        r.motivo,
        r.estado
    FROM reserva_salon r
    JOIN salon s ON r.id_salon = s.id_salon
    ORDER BY r.fecha DESC, r.hora_inicio;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_login_usuario]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [bd].[sp_login_usuario]
    @p_username VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.id_usuario,
        u.username,
        u.password_hash,
        r.nombre_rol,
        p.id_persona,
        p.primernombre,
        p.primerapellido,
        p.email
    FROM bd.usuario u
    INNER JOIN bd.rol r ON u.id_rol = r.id_rol
    INNER JOIN bd.persona p ON u.id_persona = p.id_persona
    WHERE u.username = @p_username
      AND u.activo = 1;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_persona_actualizar]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_persona_actualizar]
    @id_persona INT,
    @email VARCHAR(100),
    @telefono VARCHAR(20)
AS
BEGIN
    UPDATE persona
    SET email = @email,
        telefono = @telefono
    WHERE id_persona = @id_persona;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_persona_crear]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_persona_crear]
    @dni VARCHAR(20),
    @primer_nombre VARCHAR(50),
    @segundo_nombre VARCHAR(50),
    @primer_apellido VARCHAR(50),
    @segundo_apellido VARCHAR(50),
    @id_genero INT,
    @email VARCHAR(100),
    @telefono VARCHAR(20)
AS
BEGIN
    INSERT INTO persona (
        dni, primer_nombre, segundo_nombre,
        primer_apellido, segundo_apellido,
        id_genero, email, telefono
    )
    VALUES (
        @dni, @primer_nombre, @segundo_nombre,
        @primer_apellido, @segundo_apellido,
        @id_genero, @email, @telefono
    );
END;
GO
/****** Object:  StoredProcedure [bd].[sp_persona_desactivar]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_persona_desactivar]
    @id_persona INT
AS
BEGIN
    UPDATE persona
    SET activo = 0
    WHERE id_persona = @id_persona;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_persona_listar]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_persona_listar]
AS
BEGIN
    SELECT 
        id_persona,
        dni,
        CONCAT(primer_nombre,' ',primer_apellido) AS nombre_completo,
        email,
        telefono,
        activo
    FROM persona
    WHERE activo = 1
    ORDER BY primer_apellido;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_registrar_evaluacion]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_registrar_evaluacion]
    @id_participante INT,
    @calificacion_contenido DECIMAL(3,2),
    @calificacion_facilitador DECIMAL(3,2),
    @calificacion_organizacion DECIMAL(3,2),
    @calificacion_general DECIMAL(3,2),
    @comentarios NVARCHAR(MAX) = NULL,
    @sugerencias NVARCHAR(MAX) = NULL,
    @aplicabilidad_trabajo VARCHAR(10) = NULL,
    @recomendaria BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar si ya existe evaluación
        IF EXISTS (SELECT 1 FROM evaluacion WHERE id_participante = @id_participante)
        BEGIN
            -- Actualizar evaluación existente
            UPDATE evaluacion
            SET calificacion_contenido = @calificacion_contenido,
                calificacion_facilitador = @calificacion_facilitador,
                calificacion_organizacion = @calificacion_organizacion,
                calificacion_general = @calificacion_general,
                comentarios = @comentarios,
                sugerencias = @sugerencias,
                aplicabilidad_trabajo = @aplicabilidad_trabajo,
                recomendaria = @recomendaria,
                fecha_evaluacion = GETDATE()
            WHERE id_participante = @id_participante;
            
            SELECT 'Evaluación actualizada exitosamente' AS mensaje;
        END
        ELSE
        BEGIN
            -- Insertar nueva evaluación
            INSERT INTO evaluacion (
                id_participante, calificacion_contenido, calificacion_facilitador,
                calificacion_organizacion, calificacion_general, comentarios,
                sugerencias, aplicabilidad_trabajo, recomendaria
            )
            VALUES (
                @id_participante, @calificacion_contenido, @calificacion_facilitador,
                @calificacion_organizacion, @calificacion_general, @comentarios,
                @sugerencias, @aplicabilidad_trabajo, @recomendaria
            );
            
            SELECT 'Evaluación registrada exitosamente' AS mensaje;
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [bd].[sp_usuario_asignar_rol]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_usuario_asignar_rol]
    @id_usuario INT,
    @id_rol INT
AS
BEGIN
    INSERT INTO usuario_rol (id_usuario, id_rol)
    VALUES (@id_usuario, @id_rol);
END;
GO
/****** Object:  StoredProcedure [bd].[sp_usuario_crear]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [bd].[sp_usuario_crear]
    @id_persona INT,
    @username VARCHAR(50),
    @password_hash VARCHAR(255)
AS
BEGIN
    INSERT INTO usuario (id_persona, username, password_hash)
    VALUES (@id_persona, @username, @password_hash);
END;
GO
/****** Object:  StoredProcedure [bd].[sp_usuario_listar]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_usuario_listar]
AS
BEGIN
    SELECT 
        u.id_usuario,
        u.username,
        CONCAT(p.primer_nombre,' ',p.primer_apellido) AS persona,
        u.activo
    FROM usuario u
    JOIN persona p ON u.id_persona = p.id_persona;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_validar_disponibilidad_salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_validar_disponibilidad_salon]
    @id_salon INT,
    @fecha DATE,
    @hora_inicio TIME,
    @hora_fin TIME
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM reserva_salon
        WHERE id_salon = @id_salon
          AND fecha = @fecha
          AND estado = 'RESERVADO'
          AND (
                @hora_inicio < hora_fin
                AND @hora_fin > hora_inicio
              )
    )
        SELECT 0 AS disponible;
    ELSE
        SELECT 1 AS disponible;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_validar_login]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [bd].[sp_validar_login]
    @p_email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id_persona, 
        primernombre, 
        primerapellido, 
        email, 
        id_cargo 
    FROM persona 
    WHERE LTRIM(RTRIM(email)) = LTRIM(RTRIM(@p_email)) 
      AND activo = 1;
END;
GO
/****** Object:  StoredProcedure [bd].[sp_verificar_disponibilidad_salon]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bd].[sp_verificar_disponibilidad_salon]
    @p_id_salon INT,
    @p_fecha_inicio DATE,
    @p_hora_inicio TIME,
    @p_fecha_fin DATE,
    @p_hora_fin TIME,
    @p_disponible BIT OUTPUT,
    @p_mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @v_conflictos INT;

    SELECT @v_conflictos = COUNT(*)
    FROM evento
    WHERE id_salon = @p_id_salon
    AND id_estado NOT IN (6, 7, 8) -- Ignorar Finalizados/Cancelados/Rechazados
    AND (
        (@p_fecha_inicio BETWEEN fecha_inicio AND fecha_fin) OR
        (@p_fecha_fin BETWEEN fecha_inicio AND fecha_fin)
    )
    AND (
        (@p_hora_inicio BETWEEN hora_inicio AND hora_fin) OR 
        (@p_hora_fin BETWEEN hora_inicio AND hora_fin)
    );

    IF @v_conflictos > 0
    BEGIN
        SET @p_disponible = 0;
        SET @p_mensaje = CONCAT('El salón tiene ', @v_conflictos, ' conflicto(s) de horario');
    END
    ELSE
    BEGIN
        SET @p_disponible = 1;
        SET @p_mensaje = 'Salón disponible';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_marcar_asistencia]    Script Date: 16/2/2026 11:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_marcar_asistencia]
    @id_inscripcion INT,
    @asistio BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE bd.inscripcion
    SET asistio = @asistio
    WHERE id_inscripcion = @id_inscripcion;
END;
GO
USE [master]
GO
ALTER DATABASE [SIGECAP_DEV] SET  READ_WRITE 
GO
