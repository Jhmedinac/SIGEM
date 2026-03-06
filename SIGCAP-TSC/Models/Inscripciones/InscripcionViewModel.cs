using System.ComponentModel.DataAnnotations;

namespace SIGCAP_TSC.Models.Inscripciones
{
    public class InscripcionViewModel
    {
        public int? id_inscripcion { get; set; }
        
        [Required(ErrorMessage = "El evento es requerido")]
        public int id_evento { get; set; }
        
        [Required(ErrorMessage = "El participante es requerido")]
        public int id_persona { get; set; }
        
        public int id_estado_inscripcion { get; set; } = 1; // Por defecto Activo/Matriculado (Según tu BD)

        // Propiedades de lectura para mostrar en la grilla
        public string? codigo_evento { get; set; }
        public string? nombre_evento { get; set; }
        public string? participante_nombre { get; set; }
        public string? participante_documento { get; set; }
        public string? estado_inscripcion { get; set; }
    }

    public class InscripcionFormViewModel
    {
        public InscripcionViewModel Inscripcion { get; set; } = new InscripcionViewModel();
        public List<SIGCAP_TSC.Models.Eventos.EventoViewModel> EventosList { get; set; } = new List<SIGCAP_TSC.Models.Eventos.EventoViewModel>();
        public List<SIGCAP_TSC.Models.Participantes.ParticipanteViewModel> ParticipantesList { get; set; } = new List<SIGCAP_TSC.Models.Participantes.ParticipanteViewModel>();
    }
}
