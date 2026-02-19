using System.Collections.Generic;

namespace ApiClient.Models.Dashboard
{
    public class DashboardStatsViewModel
    {
        public int TotalUsers { get; set; }
        public int ActiveUsers { get; set; }
        public int InactiveUsers { get; set; }
        public int ActiveSalones { get; set; }
        public List<DashboardUserViewModel> LatestUsers { get; set; }
        
        // Nuevas Métricas
        public int ActiveEventsCount { get; set; }
        public int UsersInTrainingCount { get; set; }
        public List<UpcomingEventViewModel> UpcomingEvents { get; set; }
    }

    public class DashboardUserViewModel
    {
        public int CODUSR { get; set; }
        public string NOMB_USUA { get; set; }
        public bool? BLOQUEADO { get; set; }
    }

    public class UpcomingEventViewModel
    {
        public int id_evento { get; set; }
        public string nombre_evento { get; set; }
        public string fecha_inicio { get; set; } 
        public int cupo_actual { get; set; }
        public int cupo_maximo { get; set; }
        public string estado { get; set; }
    }
}
