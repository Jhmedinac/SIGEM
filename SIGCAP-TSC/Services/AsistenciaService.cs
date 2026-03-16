using Newtonsoft.Json;
using SIGCAP_TSC.Models.Asistencia;
using System.Text;

namespace SIGCAP_TSC.Services
{
    public class AsistenciaService
    {
        private readonly HttpClient _httpClient;

        public AsistenciaService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<SesionAsistenciaViewModel>> GetSesionesByEventoAsync(int idEvento, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"asistencia/sesiones/{idEvento}");
            if (!response.IsSuccessStatusCode) return new List<SesionAsistenciaViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<SesionAsistenciaViewModel>>(apiResponse?.data?.ToString() ?? "[]") ?? new List<SesionAsistenciaViewModel>();
        }

        public async Task<List<AsistenciaDetalleViewModel>> GetBySesionAsync(int idSesion, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"asistencia/sesion/{idSesion}");
            if (!response.IsSuccessStatusCode) return new List<AsistenciaDetalleViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<AsistenciaDetalleViewModel>>(apiResponse?.data?.ToString() ?? "[]") ?? new List<AsistenciaDetalleViewModel>();
        }

        public async Task<List<ResumenParticipanteViewModel>> GetResumenByEventoAsync(int idEvento, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"asistencia/resumen/{idEvento}");
            if (!response.IsSuccessStatusCode) return new List<ResumenParticipanteViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            // --- DEBUG
            Console.WriteLine($"[GetResumenByEventoAsync] JSON from backend for Event {idEvento}: {json}");
            
            try 
            {
                dynamic? apiResponse = JsonConvert.DeserializeObject(json);
                if (apiResponse?.data == null) return new List<ResumenParticipanteViewModel>();

                string dataStr = apiResponse.data.ToString();
                Console.WriteLine($"[GetResumenByEventoAsync] Data Array: {dataStr}");

                return JsonConvert.DeserializeObject<List<ResumenParticipanteViewModel>>(dataStr) ?? new List<ResumenParticipanteViewModel>();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[GetResumenByEventoAsync] Error deserializing: {ex.Message}");
                return new List<ResumenParticipanteViewModel>();
            }
        }

        public async Task<List<EstadoAsistenciaViewModel>> GetEstadosAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("asistencia/estados");
            if (!response.IsSuccessStatusCode) return new List<EstadoAsistenciaViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<EstadoAsistenciaViewModel>>(apiResponse?.data?.ToString() ?? "[]") ?? new List<EstadoAsistenciaViewModel>();
        }

        public async Task<(bool Success, string? ErrorMessage)> BulkUpsertAsync(TomarAsistenciaFormViewModel model, string token)
        {
            ConfigurarAuth(token);

            // Preparar el cuerpo según el formato esperado por el backend Node.js
            var payload = new
            {
                id_sesion = model.id_sesion,
                id_evento = model.id_evento,
                registros = model.Participantes.Select(p => new
                {
                    id_inscripcion = p.id_inscripcion,
                    id_estado_asistencia = p.id_estado_asistencia,
                    observacion = p.observacion
                }).ToList()
            };

            var jsonBody = JsonConvert.SerializeObject(payload);
            var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("asistencia/bulk", content);
            
            if (response.IsSuccessStatusCode) return (true, null);
            
            var responseBody = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(responseBody);
            return (false, errorRes?.message?.ToString() ?? "Error interno del servidor al guardar asistencia");
        }
    }
}
