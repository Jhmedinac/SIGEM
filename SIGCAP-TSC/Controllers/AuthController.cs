using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Auth;
using SIGCAP_TSC.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;

namespace SIGCAP_TSC.Controllers
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
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, model.Usuario)
                };

                var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

                await HttpContext.SignInAsync(
                    CookieAuthenticationDefaults.AuthenticationScheme,
                    new ClaimsPrincipal(claimsIdentity));

                // Guardar token en sesión para uso en otros llamados API
                HttpContext.Session.SetString("AccessToken", result.Token);
                return RedirectToAction("Index", "Dashboard");
            }

            ViewBag.Error = result.ErrorMessage; // "Usuario bloqueado", "Password no válido", etc.
            return View(model);
        }

        [HttpGet]
        public IActionResult ForgotPassword()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> ForgotPassword(string email)
        {
            if (string.IsNullOrEmpty(email))
            {
                ViewBag.Error = "Por favor ingresa un correo válido.";
                return View();
            }

            var result = await _authService.ForgotPasswordAsync(email);
            
            // Según la API node devuelve "Si el correo existe, recibirá instrucciones."
            if (result.Success || result.ErrorMessage == "Si el correo existe, recibirá instrucciones.")
            {
                ViewBag.Success = "Si el correo coincide con nuestros registros, te hemos enviado un enlace de recuperación. Revisa tu bandeja de entrada o spam.";
            }
            else
            {
                ViewBag.Error = result.ErrorMessage;
            }

            return View();
        }

        [HttpGet]
        public IActionResult ResetPassword(string token)
        {
            if (string.IsNullOrEmpty(token))
            {
                return RedirectToAction("Login", "Auth");
            }
            ViewBag.Token = token;
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> ResetPassword(string token, string newPassword, string confirmPassword)
        {
            ViewBag.Token = token;

            if (string.IsNullOrEmpty(newPassword) || newPassword != confirmPassword)
            {
                ViewBag.Error = "Las contraseñas no coinciden o están vacías.";
                return View();
            }

            var result = await _authService.ResetPasswordAsync(token, newPassword);
            
            if (result.Success || result.ErrorMessage == "Contraseña actualizada correctamente")
            {
                ViewBag.Success = "Contraseña actualizada con éxito. Ya puedes volver e iniciar sesión.";
                return View();
            }
            else
            {
                ViewBag.Error = result.ErrorMessage;
                return View();
            }
        }

        [HttpPost]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Auth");
        }
    }
}