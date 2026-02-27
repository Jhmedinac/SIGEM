using System;
using System.Collections.Generic;

namespace SIGCAP_TSC.Models.Eventos
{
    public class EventoViewModel
    {
        public int? id_evento { get; set; }
        public string codigo_evento { get; set; }
        public string nombre_evento { get; set; }
        public int? id_tipo_evento { get; set; }
        public int? id_modalidad { get; set; }
        public int? id_estado { get; set; }
        public int? id_salon { get; set; }
        public int? id_facilitador { get; set; }
        public DateTime? fecha_inicio { get; set; }
        public DateTime? fecha_fin { get; set; }
        public int cupo_maximo { get; set; }
        public int? cupo_actual { get; set; }
    }

    public class CatalogoBasicoViewModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
    }

    public class FacilitadorBasicoViewModel
    {
        public int id_facilitador { get; set; }
        public string nombre_completo { get; set; }
        public string nombres { get; set; }
        public string apellidos { get; set; }

        public string DisplayName => !string.IsNullOrEmpty(nombres) && !string.IsNullOrEmpty(apellidos) 
            ? $"{nombres} {apellidos}" 
            : nombre_completo ?? $"Facilitador #{id_facilitador}";
    }

    public class SalonBasicoViewModel
    {
        public int id_salon { get; set; }
        public string nombre_salon { get; set; }
        public string nombre { get; set; }
        public int? capacidad { get; set; }

        public string DisplayName => nombre_salon ?? nombre ?? $"Salón #{id_salon}";
    }

    public class EventoFormViewModel
    {
        public EventoViewModel Evento { get; set; }
        public List<CatalogoBasicoViewModel> TiposList { get; set; } = new List<CatalogoBasicoViewModel>();
        public List<CatalogoBasicoViewModel> ModalidadesList { get; set; } = new List<CatalogoBasicoViewModel>();
        public List<CatalogoBasicoViewModel> EstadosList { get; set; } = new List<CatalogoBasicoViewModel>();
        public List<FacilitadorBasicoViewModel> FacilitadoresList { get; set; } = new List<FacilitadorBasicoViewModel>();
        public List<SalonBasicoViewModel> SalonesList { get; set; } = new List<SalonBasicoViewModel>();
    }
}
