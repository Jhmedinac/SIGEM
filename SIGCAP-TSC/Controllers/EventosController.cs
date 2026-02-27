using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Eventos;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class EventosController : Controller
    {
        private readonly EventosService _eventosService;

        public EventosController(EventosService eventosService)
        {
            _eventosService = eventosService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var eventos = await _eventosService.GetAllAsync(token);

            // Obtener catálogos para mostrar los nombres en lugar de los IDs
            ViewBag.Tipos = await _eventosService.GetTiposAsync(token);
            ViewBag.Modalidades = await _eventosService.GetModalidadesAsync(token);
            ViewBag.Estados = await _eventosService.GetEstadosAsync(token);
            ViewBag.Salones = await _eventosService.GetSalonesAsync(token);
            ViewBag.Facilitadores = await _eventosService.GetFacilitadoresAsync(token);

            return View(eventos);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var viewModel = new EventoFormViewModel
            {
                TiposList = await _eventosService.GetTiposAsync(token),
                ModalidadesList = await _eventosService.GetModalidadesAsync(token),
                EstadosList = await _eventosService.GetEstadosAsync(token),
                FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token),
                SalonesList = await _eventosService.GetSalonesAsync(token)
            };

            if (id.HasValue && id.Value > 0)
            {
                viewModel.Evento = await _eventosService.GetByIdAsync(id.Value, token);
                if (viewModel.Evento == null) return NotFound();
            }
            else
            {
                viewModel.Evento = new EventoViewModel 
                { 
                    id_estado = 1, // Por defecto BORRADOR
                    cupo_maximo = 20
                };
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(EventoFormViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            // Solo guardaremos si el token está presente. Remitimos el Evento a la API.
            bool success = false;
            
            if (model.Evento.id_evento.HasValue && model.Evento.id_evento.Value > 0)
            {
                success = await _eventosService.UpdateAsync(model.Evento.id_evento.Value, model.Evento, token);
            }
            else
            {
                success = await _eventosService.CreateAsync(model.Evento, token);
            }

            if (success)
            {
                // TODO: Set TempData for success message
                return RedirectToAction("Index");
            }
            
            // Si hubo error, recargamos el form
            model.TiposList = await _eventosService.GetTiposAsync(token);
            model.ModalidadesList = await _eventosService.GetModalidadesAsync(token);
            model.EstadosList = await _eventosService.GetEstadosAsync(token);
            model.FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token);
            model.SalonesList = await _eventosService.GetSalonesAsync(token);
            ViewBag.Error = "No se pudo guardar el evento. Verifica los datos y el servidor.";

            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var success = await _eventosService.DeleteAsync(id, token);
            // TODO: Agregar TempData message si falla
            return RedirectToAction("Index");
        }
    }
}
