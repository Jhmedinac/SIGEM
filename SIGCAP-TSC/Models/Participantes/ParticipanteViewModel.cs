namespace SIGCAP_TSC.Models.Participantes
{
    public class ParticipanteViewModel
    {
        public int? id_persona { get; set; }
        public string identificacion { get; set; } = string.Empty;
        public string nombres { get; set; } = string.Empty;
        public string apellidos { get; set; } = string.Empty;
        public string email { get; set; } = string.Empty;
        public string? telefono { get; set; }
        public int? idCargo { get; set; }
        public int? idDireccion { get; set; }
        public int? IdDepartamento { get; set; }
        public DateTime? Feha_nacimiento { get; set; }
        public string? Genero { get; set; }
        public string? codigo_empleado { get; set; }
        public string? nivel_educativo { get; set; }
        public string? titulo_obtenido { get; set; }
        public string? tipo_nombramiento { get; set; }
        public DateTime? fecha_ingreso { get; set; }
        public string? sede_regional { get; set; }
        public bool? is_deleted { get; set; }
    }
}
