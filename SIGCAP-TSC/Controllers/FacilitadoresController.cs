using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Facilitadores;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class FacilitadoresController : Controller
    {
        private readonly FacilitadoresService _facilitadoresService;

        public FacilitadoresController(FacilitadoresService facilitadoresService)
        {
            _facilitadoresService = facilitadoresService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var facilitadores = await _facilitadoresService.GetAllAsync(token);
            return View(facilitadores);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            FacilitadorViewModel viewModel = new FacilitadorViewModel { activo = true };

            if (id.HasValue && id.Value > 0)
            {
                viewModel = await _facilitadoresService.GetByIdAsync(id.Value, token);
                if (viewModel == null) return NotFound();
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(FacilitadorViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            if (!ModelState.IsValid)
            {
                ViewBag.Error = "Verifica los datos del formulario.";
                return View("Form", model);
            }

            bool success = false;
            
            if (model.id_facilitador.HasValue && model.id_facilitador.Value > 0)
            {
                success = await _facilitadoresService.UpdateAsync(model.id_facilitador.Value, model, token);
            }
            else
            {
                success = await _facilitadoresService.CreateAsync(model, token);
            }

            if (success)
            {
                return RedirectToAction("Index");
            }
            
            ViewBag.Error = "Ocurrió un error al intentar guardar el facilitador.";
            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            await _facilitadoresService.DeleteAsync(id, token);
            return RedirectToAction("Index");
        }
    }
}
