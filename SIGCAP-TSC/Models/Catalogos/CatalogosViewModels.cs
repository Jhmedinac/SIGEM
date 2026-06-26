namespace SIGCAP_TSC.Models.Catalogos
{
    public class CargoViewModel
    {
        public int id_puesto { get; set; }
        public string codigo { get; set; } = string.Empty;
        public string nombre { get; set; } = string.Empty;
        public bool activo { get; set; }
    }

    public class DireccionViewModel
    {
        public int CodDireccion { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public int Dependencia { get; set; }
        public bool? Activa { get; set; }
    }

    public class DepartamentoViewModel
    {
        public decimal CodigoDireccion { get; set; }
        public string DescripcionDireccion { get; set; } = string.Empty;
        public decimal? Dependencia { get; set; }
        public bool? Activa { get; set; }
        public bool? Tipo { get; set; }
    }
}
