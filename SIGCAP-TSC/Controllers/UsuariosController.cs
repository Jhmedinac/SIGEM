using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Usuarios;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class UsuariosController : Controller
    {
        private readonly UsuariosService _usuariosService;

        public UsuariosController(UsuariosService usuariosService)
        {
            _usuariosService = usuariosService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var usuarios = await _usuariosService.GetAllAsync(token);
            return View(usuarios);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            UsuarioViewModel viewModel = new UsuarioViewModel { is_locked = false };

            if (id.HasValue && id.Value > 0)
            {
                viewModel = await _usuariosService.GetByIdAsync(id.Value, token);
                if (viewModel == null) return NotFound();
            }

            ViewBag.PersonasDisponibles = await _usuariosService.GetPersonasDisponiblesAsync(token);
            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(UsuarioViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            if (!ModelState.IsValid)
            {
                ViewBag.Error = "Verifica los datos del formulario.";
                ViewBag.PersonasDisponibles = await _usuariosService.GetPersonasDisponiblesAsync(token);
                return View("Form", model);
            }

            bool success = false;
            
            if (model.id_usuario.HasValue && model.id_usuario.Value > 0)
            {
                success = await _usuariosService.UpdateAsync(model.id_usuario.Value, model, token);
            }
            else
            {
                success = await _usuariosService.CreateAsync(model, token);
            }

            if (success)
            {
                return RedirectToAction("Index");
            }
            
            ViewBag.Error = "Ocurrió un error al intentar guardar el usuario. Puede que el username ya exista.";
            ViewBag.PersonasDisponibles = await _usuariosService.GetPersonasDisponiblesAsync(token);
            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            await _usuariosService.DeleteAsync(id, token);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> ToggleLock(int id, bool isLocked)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            await _usuariosService.ToggleLockAsync(id, isLocked, token);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> ResetPassword(int id, string newPassword)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var error = await _usuariosService.ResetPasswordAsync(id, newPassword, token);
            if (error != null)
            {
                TempData["Error"] = error;
            }
            else
            {
                TempData["Success"] = "Contraseña restablecida exitosamente.";
            }

            return RedirectToAction("Index");
        }
    }
}
