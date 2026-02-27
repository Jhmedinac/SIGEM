using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Profile;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class ProfileController : Controller
    {
        private readonly AuthService _authService;

        public ProfileController(AuthService authService)
        {
            _authService = authService;
        }

        public IActionResult Index()
        {
            return View(new ChangePasswordViewModel());
        }

        [HttpPost]
        public async Task<IActionResult> ChangePassword(ChangePasswordViewModel model)
        {
            var token = HttpContext.Session.GetString("AccessToken");
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            if (!ModelState.IsValid)
            {
                ViewBag.Error = "Verifica los datos ingresados.";
                return View("Index", model);
            }

            if (model.Nueva != model.Confirmar)
            {
                ViewBag.Error = "La nueva contraseña y su confirmación no coinciden.";
                return View("Index", model);
            }

            var result = await _authService.ChangePasswordAsync(model.Actual, model.Nueva, token);
            
            if (result.Success)
            {
                TempData["Success"] = result.Message;
                return RedirectToAction("Index");
            }
            
            ViewBag.Error = result.Message;
            return View("Index", model);
        }
    }
}
