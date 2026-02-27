using System.ComponentModel.DataAnnotations;

namespace SIGCAP_TSC.Models.Facilitadores
{
    public class FacilitadorViewModel
    {
        public int? id_facilitador { get; set; }

        [Required(ErrorMessage = "Los nombres son requeridos")]
        [StringLength(100)]
        public string nombres { get; set; }

        [Required(ErrorMessage = "Los apellidos son requeridos")]
        [StringLength(100)]
        public string apellidos { get; set; }

        [Required(ErrorMessage = "La especialidad es requerida")]
        [StringLength(200)]
        public string especialidad { get; set; }

        [EmailAddress(ErrorMessage = "Correo electrónico no válido")]
        public string email { get; set; }

        [StringLength(20)]
        public string telefono { get; set; }

        public bool? activo { get; set; }
        
        public string nombre_completo => string.IsNullOrEmpty(nombres) ? "" : $"{nombres} {apellidos}".Trim();
    }
}
