using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class AlertasController : Controller
    {
        private readonly AlertasService _alertasService;

        public AlertasController(AlertasService alertasService)
        {
            _alertasService = alertasService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var alertas = await _alertasService.GetAllAsync(token);
            var counts = await _alertasService.GetCountAsync(token);

            ViewBag.Counts = counts;
            return View(alertas);
        }
    }
}
