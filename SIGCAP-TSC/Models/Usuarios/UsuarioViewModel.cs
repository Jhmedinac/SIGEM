namespace SIGCAP_TSC.Models.Usuarios
{
    public class UsuarioViewModel
    {
        public int? id_usuario { get; set; }
        public string username { get; set; }
        public string password { get; set; } // Opcional, solo en creación o reset
        public int id_persona { get; set; }
        public string PersonaNombre { get; set; } // Data mostrada del JOIN en DB
        public bool is_locked { get; set; }
        public bool is_deleted { get; set; }
    }

    public class PersonaDisponibleViewModel
    {
        public int id_persona { get; set; }
        public string nombres { get; set; }
        public string apellidos { get; set; }
        public string identificacion { get; set; }
    }
}
