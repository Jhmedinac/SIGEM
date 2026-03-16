namespace SIGCAP_TSC.Models.Asistencia
{
    public class SesionAsistenciaViewModel
    {
        public int id_sesion { get; set; }
        public int id_evento { get; set; }
        public string nombre_sesion { get; set; }
        public DateTime fecha_sesion { get; set; }
        public string hora_inicio { get; set; }
        public string hora_fin { get; set; }
        public bool is_deleted { get; set; }
        public int registros_asistencia { get; set; }
    }

    public class AsistenciaDetalleViewModel
    {
        public int? id_asistencia { get; set; }
        public int id_inscripcion { get; set; }
        public int? id_estado_asistencia { get; set; }
        public string? observacion { get; set; }
        public string nombre_participante { get; set; }
        public string identificacion { get; set; }
        public int id_persona { get; set; }
        public string? estado_asistencia { get; set; }
        public string? codigo_asistencia { get; set; }
    }

    public class ResumenParticipanteViewModel
    {
        public int id_persona { get; set; }
        public string identificacion { get; set; }
        public string nombre_participante { get; set; }
        public int total_sesiones { get; set; }
        public int presentes { get; set; }
        public int ausentes { get; set; }
        public int tardanzas { get; set; }
        public int justificados { get; set; }
        public decimal porcentaje_asistencia { get; set; }
    }

    public class EstadoAsistenciaViewModel
    {
        public int id_estado_asistencia { get; set; }
        public string codigo { get; set; }
        public string nombre { get; set; }
        public decimal peso_valor { get; set; }
    }

    public class TomarAsistenciaFormViewModel
    {
        public int id_sesion { get; set; }
        public int id_evento { get; set; }
        public string nombre_sesion { get; set; }
        public DateTime fecha_sesion { get; set; }
        public List<AsistenciaDetalleViewModel> Participantes { get; set; } = new();
        public List<EstadoAsistenciaViewModel> EstadosAsistencia { get; set; } = new();
    }
}
