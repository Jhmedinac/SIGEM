namespace SIGCAP_TSC.Models.Participantes
{
    public class ParticipanteViewModel
    {
        public int? id_persona { get; set; }
        public string identificacion { get; set; }
        public string nombres { get; set; }
        public string apellidos { get; set; }
        public string email { get; set; }
        public bool? is_deleted { get; set; }
    }
}
