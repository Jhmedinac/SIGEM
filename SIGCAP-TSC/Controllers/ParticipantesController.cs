using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Participantes;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class ParticipantesController : Controller
    {
        private readonly ParticipantesService _participantesService;

        public ParticipantesController(ParticipantesService participantesService)
        {
            _participantesService = participantesService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var participantes = await _participantesService.GetAllAsync(token);
            return View(participantes);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            ParticipanteViewModel viewModel = new ParticipanteViewModel { is_deleted = false };

            if (id.HasValue && id.Value > 0)
            {
                viewModel = await _participantesService.GetByIdAsync(id.Value, token);
                if (viewModel == null) return NotFound();
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(ParticipanteViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            if (!ModelState.IsValid)
            {
                ViewBag.Error = "Verifica los datos del formulario.";
                return View("Form", model);
            }

            bool success = false;
            
            if (model.id_persona.HasValue && model.id_persona.Value > 0)
            {
                success = await _participantesService.UpdateAsync(model.id_persona.Value, model, token);
            }
            else
            {
                success = await _participantesService.CreateAsync(model, token);
            }

            if (success)
            {
                return RedirectToAction("Index");
            }
            
            ViewBag.Error = "Ocurrió un error al intentar guardar el participante.";
            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            await _participantesService.DeleteAsync(id, token);
            return RedirectToAction("Index");
        }
    }
}
