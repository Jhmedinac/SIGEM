using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.ViewComponents
{
    public class NotificationBadgeViewComponent : ViewComponent
    {
        private readonly AlertasService _alertasService;

        public NotificationBadgeViewComponent(AlertasService alertasService)
        {
            _alertasService = alertasService;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var token = HttpContext.Session.GetString("AccessToken");
            if (string.IsNullOrEmpty(token))
            {
                return View("Default", 0);
            }

            var counts = await _alertasService.GetCountAsync(token);
            return View("Default", counts.critical); // Solo mostramos el badge rojo si hay alertas críticas
        }
    }
}
