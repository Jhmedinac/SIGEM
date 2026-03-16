using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIGCAP_TSC.Models.Eventos;
using SIGCAP_TSC.Services;

namespace SIGCAP_TSC.Controllers
{
    [Authorize]
    public class EventosController : Controller
    {
        private readonly EventosService _eventosService;
        private readonly AsistenciaService _asistenciaService;

        public EventosController(EventosService eventosService, AsistenciaService asistenciaService)
        {
            _eventosService = eventosService;
            _asistenciaService = asistenciaService;
        }

        private string GetToken() => HttpContext.Session.GetString("AccessToken");

        public async Task<IActionResult> Index()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var eventos = await _eventosService.GetAllAsync(token);

            // Obtener catálogos para mostrar los nombres en lugar de los IDs
            ViewBag.Tipos = await _eventosService.GetTiposAsync(token);
            ViewBag.Modalidades = await _eventosService.GetModalidadesAsync(token);
            ViewBag.Estados = await _eventosService.GetEstadosAsync(token);
            ViewBag.Salones = await _eventosService.GetSalonesAsync(token);
            ViewBag.Facilitadores = await _eventosService.GetFacilitadoresAsync(token);

            return View(eventos);
        }

        public async Task<IActionResult> Form(int? id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var viewModel = new EventoFormViewModel
            {
                TiposList = await _eventosService.GetTiposAsync(token),
                ModalidadesList = await _eventosService.GetModalidadesAsync(token),
                EstadosList = await _eventosService.GetEstadosAsync(token),
                FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token),
                SalonesList = await _eventosService.GetSalonesAsync(token)
            };

            if (id.HasValue && id.Value > 0)
            {
                viewModel.Evento = await _eventosService.GetByIdAsync(id.Value, token);
                if (viewModel.Evento == null) return NotFound();

                // Verificar si tiene sesiones existentes
                var sesiones = await _asistenciaService.GetSesionesByEventoAsync(id.Value, token);
                ViewBag.TieneSesiones = sesiones != null && sesiones.Any();
            }
            else
            {
                ViewBag.TieneSesiones = false;
                viewModel.Evento = new EventoViewModel 
                { 
                    id_estado = 1, // Por defecto BORRADOR
                    cupo_maximo = 20
                };
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Save(EventoFormViewModel model)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            // ===== DEBUG: Log ModelState errors =====
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                    .SelectMany(v => v.Errors)
                    .Select(e => e.ErrorMessage)
                    .ToList();
                Console.WriteLine("MODELSTATE INVALID: " + string.Join(", ", errors));
                foreach (var kv in ModelState)
                {
                    if (kv.Value.Errors.Count > 0)
                        Console.WriteLine($"  Key: {kv.Key}, Errors: {string.Join(", ", kv.Value.Errors.Select(e => e.ErrorMessage))}");
                }
                // Recargar catálogos y retornar con errores
                model.TiposList = await _eventosService.GetTiposAsync(token);
                model.ModalidadesList = await _eventosService.GetModalidadesAsync(token);
                model.EstadosList = await _eventosService.GetEstadosAsync(token);
                model.FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token);
                model.SalonesList = await _eventosService.GetSalonesAsync(token);
                ViewBag.Error = "Verifica los campos requeridos: " + string.Join(", ", errors);
                return View("Form", model);
            }
            // ==========================================

            Console.WriteLine($"[Save] Token OK (primeros 20 chars): {(token?.Length > 20 ? token.Substring(0, 20) : token)}");
            Console.WriteLine($"[Save] Evento: codigo={model.Evento.codigo_evento}, nombre={model.Evento.nombre_evento}, inicio={model.Evento.fecha_inicio:yyyy-MM-dd}, fin={model.Evento.fecha_fin:yyyy-MM-dd}, tipo={model.Evento.id_tipo_evento}, modalidad={model.Evento.id_modalidad}, estado={model.Evento.id_estado}");

            bool success = false;
            string? errorMessage = null;
            
            if (model.Evento.id_evento.HasValue && model.Evento.id_evento.Value > 0)
            {
                Console.WriteLine($"[Save] Updating evento ID={model.Evento.id_evento.Value}");
                var result = await _eventosService.UpdateAsync(model.Evento.id_evento.Value, model.Evento, token);
                success = result.Success;
                errorMessage = result.ErrorMessage;
                Console.WriteLine($"[Save] Update result: success={result.Success}, error={result.ErrorMessage}");
            }
            else
            {
                Console.WriteLine($"[Save] Creating nuevo evento...");
                var result = await _eventosService.CreateAsync(model.Evento, token);
                success = result.Success;
                errorMessage = result.ErrorMessage;
                Console.WriteLine($"[Save] Create result: success={result.Success}, error={result.ErrorMessage}");
            }

            if (success)
            {
                return RedirectToAction("Index");
            }
            
            // Si hubo error, recargamos el form
            model.TiposList = await _eventosService.GetTiposAsync(token);
            model.ModalidadesList = await _eventosService.GetModalidadesAsync(token);
            model.EstadosList = await _eventosService.GetEstadosAsync(token);
            model.FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token);
            model.SalonesList = await _eventosService.GetSalonesAsync(token);
            ViewBag.Error = errorMessage ?? "No se pudo guardar el evento. Verifica los datos y el servidor.";

            return View("Form", model);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var success = await _eventosService.DeleteAsync(id, token);
            // TODO: Agregar TempData message si falla
            return RedirectToAction("Index");
        }

        // ===== REPORTE DE PARTICIPANTES =====
        public async Task<IActionResult> Participantes(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var reporte = await _eventosService.GetParticipantesReporteAsync(id, token);
            if (reporte == null) return NotFound();

            var viewModel = new EventoParticipantesViewModel
            {
                Evento = reporte.evento,
                Participantes = reporte.participantes,
                Total = reporte.total,
                EstadosList = await _eventosService.GetEstadosAsync(token),
                FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token),
                SalonesList = await _eventosService.GetSalonesAsync(token)
            };

            return View(viewModel);
        }

        public async Task<IActionResult> ExportarParticipantesCsv(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var reporte = await _eventosService.GetParticipantesReporteAsync(id, token);
            if (reporte == null) return NotFound();

            var sb = new System.Text.StringBuilder();
            sb.AppendLine("No.,Identificación,Nombres,Apellidos,Email,Fecha Inscripción,Estado,Nota Final");
            
            int row = 1;
            foreach (var p in reporte.participantes)
            {
                var fecha = p.fecha_inscripcion?.ToString("yyyy-MM-dd") ?? "";
                var nota = p.nota_final?.ToString("F2") ?? "";
                sb.AppendLine($"{row},\"{p.identificacion}\",\"{p.nombres}\",\"{p.apellidos}\",\"{p.email}\",{fecha},{p.estado_inscripcion},{nota}");
                row++;
            }

            var fileName = $"Participantes_{reporte.evento?.codigo_evento ?? "evento"}_{DateTime.Now:yyyyMMdd}.csv";
            var bytes = System.Text.Encoding.UTF8.GetPreamble().Concat(System.Text.Encoding.UTF8.GetBytes(sb.ToString())).ToArray();
            return File(bytes, "text/csv; charset=utf-8", fileName);
        }

        // ===== REPOSITORIO HISTÓRICO =====
        public async Task<IActionResult> Historico()
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var eventos = await _eventosService.GetHistoricoAsync(token);

            ViewBag.Tipos = await _eventosService.GetTiposAsync(token);
            ViewBag.Modalidades = await _eventosService.GetModalidadesAsync(token);
            ViewBag.Estados = await _eventosService.GetEstadosAsync(token);
            ViewBag.Salones = await _eventosService.GetSalonesAsync(token);
            ViewBag.Facilitadores = await _eventosService.GetFacilitadoresAsync(token);

            return View(eventos);
        }

        public async Task<IActionResult> HistoricoDetalle(int id)
        {
            var token = GetToken();
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            var reporte = await _eventosService.GetParticipantesReporteAsync(id, token);
            if (reporte == null) return NotFound();

            var viewModel = new EventoParticipantesViewModel
            {
                Evento = reporte.evento,
                Participantes = reporte.participantes,
                Total = reporte.total,
                EstadosList = await _eventosService.GetEstadosAsync(token),
                FacilitadoresList = await _eventosService.GetFacilitadoresAsync(token),
                SalonesList = await _eventosService.GetSalonesAsync(token)
            };

            return View(viewModel);
        }
    }
}
