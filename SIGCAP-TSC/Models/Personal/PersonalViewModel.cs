namespace SIGCAP_TSC.Models.Personal
{
    public class PersonalViewModel
    {
        public int? id_personal { get; set; }
        public string? identificacion { get; set; }
        public string? nombres { get; set; }
        public string? apellidos { get; set; }
        public string? email { get; set; }
        public string? telefono { get; set; }
        public bool is_deleted { get; set; }
    }
}
