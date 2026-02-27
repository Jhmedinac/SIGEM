namespace SIGCAP_TSC.Models.Alertas
{
    public class AlertaViewModel
    {
        public string id { get; set; }
        public string tipo { get; set; }
        public string nivel { get; set; } // critical, warning, info
        public string titulo { get; set; }
        public string descripcion { get; set; }
        public string codigo { get; set; }
        public AlertaMeta meta { get; set; }
    }

    public class AlertaMeta
    {
        public DateTime? fecha_inicio { get; set; }
        public DateTime? fecha_fin { get; set; }
        public decimal? pct { get; set; }
        public List<AlertaUsuario> usuarios { get; set; }
    }

    public class AlertaUsuario
    {
        public int id_usuario { get; set; }
        public string username { get; set; }
        public string nombre_completo { get; set; }
    }

    public class AlertaCount
    {
        public int total { get; set; }
        public int critical { get; set; }
        public int warning { get; set; }
        public int info { get; set; }
    }
}
