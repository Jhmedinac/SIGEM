using Microsoft.AspNetCore.Mvc;
using ApiClient.Models.Auth;
using ApiClient.Services;
namespace ApiClient.Controllers
{
    public class AuthController : Controller
    {
        private readonly AuthService _authService;
        public AuthController(AuthService authService)
        {
            _authService = authService;
        }
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            var result = await _authService.LoginAsync(model.Usuario, model.Password);
            
            if (result.Success)
            {
                // Guardar token en sesión
                HttpContext.Session.SetString("AccessToken", result.Token);
                return RedirectToAction("Index", "Dashboard");
            }

            ViewBag.Error = result.ErrorMessage; // "Usuario bloqueado", "Password no válido", etc.
            return View(model);
        }
    }
}