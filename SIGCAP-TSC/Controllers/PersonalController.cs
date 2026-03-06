using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Personal;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class PersonalController : Controller
    {
        private readonly PersonalService _personalService;

        public PersonalController(PersonalService personalService)
        {
            _personalService = personalService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var personal = await _personalService.GetAllAsync(token);
            return View(personal);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            PersonalViewModel viewModel = new PersonalViewModel();

            if (id.HasValue && id.Value > 0)
            {
                viewModel = await _personalService.GetByIdAsync(id.Value, token);
                if (viewModel == null) return NotFound();
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(PersonalViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            if (!ModelState.IsValid)
            {
                ViewBag.Error = "Verifica los datos del formulario.";
                return View("Form", model);
            }

            bool success = false;
            
            if (model.id_personal.HasValue && model.id_personal.Value > 0)
            {
                success = await _personalService.UpdateAsync(model.id_personal.Value, model, token);
            }
            else
            {
                success = await _personalService.CreateAsync(model, token);
            }

            if (success)
            {
                TempData["Success"] = "Personal guardado correctamente.";
                return RedirectToAction("Index");
            }
            
            ViewBag.Error = "Ocurrió un error al intentar guardar. Verifica si la identificación ya existe.";
            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            bool success = await _personalService.DeleteAsync(id, token);
            if (success) {
                TempData["Success"] = "Personal eliminado correctamente.";
            } else {
                TempData["Error"] = "Ocurrió un error al eliminar el personal.";
            }
            return RedirectToAction("Index");
        }
    }
}
