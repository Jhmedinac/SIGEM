using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Eventos;

namespace SIGCAP_TSC.Services
{
    public class EventosService
    {
        private readonly HttpClient _httpClient;

        public EventosService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<EventoViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("eventos");
            if (!response.IsSuccessStatusCode) return new List<EventoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            try
            {
                dynamic? apiResponse = JsonConvert.DeserializeObject(json);
                if (apiResponse?.data == null) 
                {
                    Console.WriteLine("API RESPONSE DATA IS NULL!");
                    Console.WriteLine("JSON: " + json);
                    return new List<EventoViewModel>();
                }
                var list = JsonConvert.DeserializeObject<List<EventoViewModel>>(apiResponse.data.ToString());
                Console.WriteLine($"SUCCESSFULLY DESERIALIZED {list?.Count ?? 0} EVENTOS");
                return list ?? new List<EventoViewModel>();
            }
            catch (Exception ex)
            {
                Console.WriteLine("ERROR DESERIALIZING EVENTOS: " + ex.Message);
                Console.WriteLine("JSON Original: " + json);
                return new List<EventoViewModel>();
            }
        }

        public async Task<EventoViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"eventos/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<EventoViewModel>(apiResponse.data.ToString());
        }

        public async Task<(bool Success, string? ErrorMessage)> GenerarSesionesAsync(int idEvento, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.PostAsync($"eventos/{idEvento}/generar-sesiones", null);
            
            if (response.IsSuccessStatusCode) return (true, null);
            
            var responseBody = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(responseBody);
            return (false, errorRes?.message?.ToString() ?? "Error interno del servidor al generar sesiones");
        }

        public async Task<(bool Success, string? ErrorMessage)> CreateAsync(EventoViewModel evento, string token)
        {
            ConfigurarAuth(token);
            var jsonBody = JsonConvert.SerializeObject(evento);
            Console.WriteLine($"[CreateAsync] Token (primeros 30 chars): {(token?.Length > 30 ? token.Substring(0, 30) : token)}");
            Console.WriteLine($"[CreateAsync] JSON enviado al API: {jsonBody}");
            
            var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("eventos", content);
            
            var responseBody = await response.Content.ReadAsStringAsync();
            Console.WriteLine($"[CreateAsync] HTTP Status: {(int)response.StatusCode} {response.StatusCode}");
            Console.WriteLine($"[CreateAsync] Response body: {responseBody}");
            
            if (response.IsSuccessStatusCode) return (true, null);
            
            dynamic? errorRes = JsonConvert.DeserializeObject(responseBody);
            return (false, errorRes?.message?.ToString() ?? "Error interno del servidor");
        }

        public async Task<(bool Success, string? ErrorMessage)> UpdateAsync(int id, EventoViewModel evento, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(evento), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"eventos/{id}", content);
            
            if (response.IsSuccessStatusCode) return (true, null);
            
            var errorJson = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(errorJson);
            return (false, errorRes?.message?.ToString() ?? "Error interno del servidor");
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"eventos/{id}");
            return response.IsSuccessStatusCode;
        }

        // --- CATALOGOS MINIMOS ---
        public async Task<List<CatalogoBasicoViewModel>> GetTiposAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("eventos/catalogos/tipos");
            if (!response.IsSuccessStatusCode) return new List<CatalogoBasicoViewModel>();
            var json = await response.Content.ReadAsStringAsync();
            dynamic apiRes = JsonConvert.DeserializeObject(json);
            var list = new List<CatalogoBasicoViewModel>();
            foreach (var item in apiRes.data)
            {
                list.Add(new CatalogoBasicoViewModel { Id = item.id_tipo_evento, Nombre = item.nombre });
            }
            return list;
        }

        public async Task<List<CatalogoBasicoViewModel>> GetModalidadesAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("eventos/catalogos/modalidades");
            if (!response.IsSuccessStatusCode) return new List<CatalogoBasicoViewModel>();
            var json = await response.Content.ReadAsStringAsync();
            dynamic apiRes = JsonConvert.DeserializeObject(json);
            var list = new List<CatalogoBasicoViewModel>();
            foreach (var item in apiRes.data)
            {
                list.Add(new CatalogoBasicoViewModel { Id = item.id_modalidad, Nombre = item.nombre });
            }
            return list;
        }

        public async Task<List<CatalogoBasicoViewModel>> GetEstadosAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("eventos/catalogos/estados");
            if (!response.IsSuccessStatusCode) return new List<CatalogoBasicoViewModel>();
            var json = await response.Content.ReadAsStringAsync();
            dynamic apiRes = JsonConvert.DeserializeObject(json);
            var list = new List<CatalogoBasicoViewModel>();
            foreach (var item in apiRes.data)
            {
                // El backend retorna id_estado
                list.Add(new CatalogoBasicoViewModel { Id = item.id_estado, Nombre = item.nombre });
            }
            return list;
        }

        public async Task<List<SalonBasicoViewModel>> GetSalonesAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("salones");
            if (!response.IsSuccessStatusCode) return new List<SalonBasicoViewModel>();
            var json = await response.Content.ReadAsStringAsync();
            dynamic apiRes = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<SalonBasicoViewModel>>(apiRes.data.ToString()) ?? new List<SalonBasicoViewModel>();
        }

        public async Task<List<FacilitadorBasicoViewModel>> GetFacilitadoresAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("facilitadores");
            if (!response.IsSuccessStatusCode) return new List<FacilitadorBasicoViewModel>();
            var json = await response.Content.ReadAsStringAsync();
            dynamic apiRes = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<FacilitadorBasicoViewModel>>(apiRes.data.ToString()) ?? new List<FacilitadorBasicoViewModel>();
        }

        public async Task<List<EventoViewModel>> GetHistoricoAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("eventos/historico");
            if (!response.IsSuccessStatusCode) return new List<EventoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            try
            {
                dynamic? apiResponse = JsonConvert.DeserializeObject(json);
                if (apiResponse?.data == null) return new List<EventoViewModel>();
                var list = JsonConvert.DeserializeObject<List<EventoViewModel>>(apiResponse.data.ToString());
                return list ?? new List<EventoViewModel>();
            }
            catch (Exception ex)
            {
                Console.WriteLine("ERROR DESERIALIZING HISTORICO: " + ex.Message);
                return new List<EventoViewModel>();
            }
        }

        public async Task<ParticipantesReporteResponse> GetParticipantesReporteAsync(int idEvento, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"eventos/{idEvento}/participantes-reporte");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            try
            {
                dynamic? apiResponse = JsonConvert.DeserializeObject(json);
                if (apiResponse?.data == null) return null;
                return JsonConvert.DeserializeObject<ParticipantesReporteResponse>(apiResponse.data.ToString());
            }
            catch (Exception ex)
            {
                Console.WriteLine("ERROR DESERIALIZING PARTICIPANTES REPORTE: " + ex.Message);
                return null;
            }
        }
    }
}
