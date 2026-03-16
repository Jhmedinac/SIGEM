namespace SIGCAP_TSC.Models.Eventos
{
    public class ParticipanteReporteViewModel
    {
        public int id_inscripcion { get; set; }
        public string identificacion { get; set; }
        public string nombre_participante { get; set; }
        public string nombres { get; set; }
        public string apellidos { get; set; }
        public string email { get; set; }
        public DateTime? fecha_inscripcion { get; set; }
        public string estado_inscripcion { get; set; }
        public string codigo_estado { get; set; }
        public decimal? nota_final { get; set; }
    }

    public class ParticipantesReporteResponse
    {
        public EventoViewModel evento { get; set; }
        public List<ParticipanteReporteViewModel> participantes { get; set; } = new List<ParticipanteReporteViewModel>();
        public int total { get; set; }
    }

    public class EventoParticipantesViewModel
    {
        public EventoViewModel Evento { get; set; }
        public List<ParticipanteReporteViewModel> Participantes { get; set; } = new List<ParticipanteReporteViewModel>();
        public int Total { get; set; }
        // Catálogos para mostrar nombres
        public List<CatalogoBasicoViewModel> EstadosList { get; set; } = new List<CatalogoBasicoViewModel>();
        public List<FacilitadorBasicoViewModel> FacilitadoresList { get; set; } = new List<FacilitadorBasicoViewModel>();
        public List<SalonBasicoViewModel> SalonesList { get; set; } = new List<SalonBasicoViewModel>();
    }
}
