using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Inscripciones;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class InscripcionesController : Controller
    {
        private readonly InscripcionesService _inscripcionesService;
        private readonly EventosService _eventosService;
        private readonly ParticipantesService _participantesService;

        public InscripcionesController(
            InscripcionesService inscripcionesService,
            EventosService eventosService,
            ParticipantesService participantesService)
        {
            _inscripcionesService = inscripcionesService;
            _eventosService = eventosService;
            _participantesService = participantesService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var inscripciones = await _inscripcionesService.GetAllAsync(token);
            return View(inscripciones);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var viewModel = new InscripcionFormViewModel
            {
                EventosList = await _eventosService.GetAllAsync(token),
                ParticipantesList = await _participantesService.GetAllAsync(token)
            };

            if (id.HasValue && id.Value > 0)
            {
                viewModel.Inscripcion = await _inscripcionesService.GetByIdAsync(id.Value, token);
                if (viewModel.Inscripcion == null) return NotFound();
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(InscripcionFormViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            bool success = false;
            string? errorMessage = null;
            
            if (model.Inscripcion.id_inscripcion.HasValue && model.Inscripcion.id_inscripcion.Value > 0)
            {
                var result = await _inscripcionesService.UpdateAsync(model.Inscripcion.id_inscripcion.Value, model.Inscripcion, token);
                success = result.Success;
                errorMessage = result.ErrorMessage;
            }
            else
            {
                var result = await _inscripcionesService.CreateAsync(model.Inscripcion, token);
                success = result.Success;
                errorMessage = result.ErrorMessage;
            }

            if (success)
            {
                return RedirectToAction("Index");
            }
            
            model.EventosList = await _eventosService.GetAllAsync(token);
            model.ParticipantesList = await _participantesService.GetAllAsync(token);
            ViewBag.Error = errorMessage ?? "No se pudo guardar la inscripción. Verifica los datos.";

            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            await _inscripcionesService.DeleteAsync(id, token);
            return RedirectToAction("Index");
        }
    }
}
