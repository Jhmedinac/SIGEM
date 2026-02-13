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
    }

    public class DashboardUserViewModel
    {
        public int CODUSR { get; set; }
        public string NOMB_USUA { get; set; }
        public bool? BLOQUEADO { get; set; }
    }
}
