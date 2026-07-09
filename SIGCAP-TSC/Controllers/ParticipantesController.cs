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
        private readonly GeograficoService _geograficoService;
        private readonly CatalogosService _catalogosService;

        public ParticipantesController(ParticipantesService participantesService, GeograficoService geograficoService, CatalogosService catalogosService)
        {
            _participantesService = participantesService;
            _geograficoService = geograficoService;
            _catalogosService = catalogosService;
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

            // Cargar departamentos desde el catálogo geográfico
            var departamentos = await _geograficoService.GetDepartamentosAsync(token);
            ViewBag.Departamentos = departamentos;

            // Cargar catálogos institucionales
            var cargos = await _catalogosService.GetCargosAsync(token);
            var direcciones = await _catalogosService.GetDireccionesAsync(token);
            var gerencias = await _catalogosService.GetDepartamentosAsync(token);

            ViewBag.Cargos = cargos;
            ViewBag.Direcciones = direcciones;
            ViewBag.Gerencias = gerencias;

            ParticipanteViewModel viewModel = new ParticipanteViewModel { is_deleted = false };

            if (id.HasValue && id.Value > 0)
            {
                viewModel = await _participantesService.GetByIdAsync(id.Value, token);
                if (viewModel == null) return NotFound();
            }

            return View(viewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetMunicipios(int departamentoId)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return Unauthorized();

            var municipios = await _geograficoService.GetMunicipiosAsync(departamentoId, token);
            return Json(municipios);
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
            string? errorMessage = null;

            if (model.id_persona.HasValue && model.id_persona.Value > 0)
            {
                var result = await _participantesService.UpdateAsync(model.id_persona.Value, model, token);
                success = result.Success;
                errorMessage = result.ErrorMessage;
            }
            else
            {
                var result = await _participantesService.CreateAsync(model, token);
                success = result.Success;
                errorMessage = result.ErrorMessage;
            }

            if (success)
            {
                return RedirectToAction("Index");
            }

            ViewBag.Error = errorMessage ?? "Ocurrió un error al intentar guardar el participante.";
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
