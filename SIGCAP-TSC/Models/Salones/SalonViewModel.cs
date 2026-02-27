namespace SIGCAP_TSC.Models.Salones
{
    public class SalonViewModel
    {
        public int? id_salon { get; set; }
        public string nombre_salon { get; set; }
        public int? capacidad { get; set; }
        public string ubicacion { get; set; }
        public bool? activo { get; set; }
    }
}
