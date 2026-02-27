using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Salones;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class SalonesController : Controller
    {
        private readonly SalonesService _salonesService;

        public SalonesController(SalonesService salonesService)
        {
            _salonesService = salonesService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var salones = await _salonesService.GetAllAsync(token);
            return View(salones);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            SalonViewModel viewModel = new SalonViewModel { activo = true };

            if (id.HasValue && id.Value > 0)
            {
                viewModel = await _salonesService.GetByIdAsync(id.Value, token);
                if (viewModel == null) return NotFound();
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(SalonViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            // Validar modelo usando las reglas de DataAnnotations en C#
            if (!ModelState.IsValid)
            {
                ViewBag.Error = "Verifica los datos del formulario.";
                return View("Form", model);
            }

            bool success = false;
            
            if (model.id_salon.HasValue && model.id_salon.Value > 0)
            {
                success = await _salonesService.UpdateAsync(model.id_salon.Value, model, token);
            }
            else
            {
                success = await _salonesService.CreateAsync(model, token);
            }

            if (success)
            {
                return RedirectToAction("Index");
            }
            
            ViewBag.Error = "Ocurrió un error al intentar guardar el salón.";
            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            await _salonesService.DeleteAsync(id, token);
            return RedirectToAction("Index");
        }
    }
}
