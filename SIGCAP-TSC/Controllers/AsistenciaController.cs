using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Asistencia;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class AsistenciaController : Controller
    {
        private readonly AsistenciaService _asistenciaService;
        private readonly EventosService _eventosService;

        public AsistenciaController(AsistenciaService asistenciaService, EventosService eventosService)
        {
            _asistenciaService = asistenciaService;
            _eventosService = eventosService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken") ?? "";

        // Dashboard del Evento: Muestra participantes y listado de sesiones
        public async Task<IActionResult> Index(int id) // id = id_evento
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            // Obtener info del evento para el encabezado
            var evento = await _eventosService.GetByIdAsync(id, token);
            if (evento == null) return NotFound("Evento no encontrado");
            
            ViewBag.Evento = evento;

            // Obtener resumen de participantes inscritos
            var participantes = await _asistenciaService.GetResumenByEventoAsync(id, token);
            
            // Obtener sesiones para poder ir a tomar asistencia
            var sesiones = await _asistenciaService.GetSesionesByEventoAsync(id, token);

            ViewBag.Sesiones = sesiones;
            
            return View(participantes);
        }

        [HttpPost]
        public async Task<IActionResult> GenerarSesiones(int idEvento)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var result = await _eventosService.GenerarSesionesAsync(idEvento, token);
            
            if (result.Success)
            {
                TempData["SuccessMessage"] = "Sesiones generadas correctamente.";
            }
            else
            {
                TempData["ErrorMessage"] = result.ErrorMessage ?? "Error al generar las sesiones.";
            }

            return RedirectToAction("Index", new { id = idEvento });
        }

        // Pantalla para tomar asistencia de una sesión específica
        public async Task<IActionResult> Tomar(int idSesion, int idEvento)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var evento = await _eventosService.GetByIdAsync(idEvento, token);
            if (evento == null) return NotFound("Evento no encontrado");
            ViewBag.Evento = evento;

            var sesiones = await _asistenciaService.GetSesionesByEventoAsync(idEvento, token);
            var sesionActual = sesiones.FirstOrDefault(s => s.id_sesion == idSesion);
            if (sesionActual == null) return NotFound("Sesión no encontrada");

            ViewBag.Sesion = sesionActual;

            var participantes = await _asistenciaService.GetBySesionAsync(idSesion, token);
            var estados = await _asistenciaService.GetEstadosAsync(token);

            // Si algún participante aún no tiene estado asignado, asignar el primer estado por defecto (ej. Presente)
            var idEstadoDefault = estados.FirstOrDefault()?.id_estado_asistencia ?? 0;
            foreach (var p in participantes)
            {
                if (!p.id_estado_asistencia.HasValue)
                {
                    p.id_estado_asistencia = idEstadoDefault;
                }
            }

            var viewModel = new TomarAsistenciaFormViewModel
            {
                id_sesion = idSesion,
                id_evento = idEvento,
                nombre_sesion = sesionActual.nombre_sesion,
                fecha_sesion = sesionActual.fecha_sesion,
                Participantes = participantes,
                EstadosAsistencia = estados
            };

            return View(viewModel);
        }

        // Procesar el guardado de la asistencia
        [HttpPost]
        public async Task<IActionResult> SaveBulk(TomarAsistenciaFormViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var result = await _asistenciaService.BulkUpsertAsync(model, token);
            
            if (result.Success)
            {
                TempData["SuccessMessage"] = "Asistencia guardada correctamente.";
                return RedirectToAction("Index", new { id = model.id_evento });
            }

            // En caso de error, recargar la vista con el error
            ViewBag.Error = result.ErrorMessage;
            
            var evento = await _eventosService.GetByIdAsync(model.id_evento, token);
            ViewBag.Evento = evento;
            
            var sesiones = await _asistenciaService.GetSesionesByEventoAsync(model.id_evento, token);
            ViewBag.Sesion = sesiones.FirstOrDefault(s => s.id_sesion == model.id_sesion);

            model.EstadosAsistencia = await _asistenciaService.GetEstadosAsync(token);

            return View("Tomar", model);
        }
    }
}
