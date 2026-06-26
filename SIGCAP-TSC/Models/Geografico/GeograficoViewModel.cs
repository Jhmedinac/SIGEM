namespace SIGCAP_TSC.Models.Geografico
{
    public class GeograficoViewModel
    {
        public int codigo_geografico { get; set; }
        public int departamento { get; set; }
        public int municipio { get; set; }
        public int nivel { get; set; }
        public string nombre { get; set; } = string.Empty;
        public string? siglas { get; set; }
        public bool estado { get; set; }
    }
}
