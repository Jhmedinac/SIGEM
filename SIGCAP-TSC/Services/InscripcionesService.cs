using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Inscripciones;

namespace SIGCAP_TSC.Services
{
    public class InscripcionesService
    {
        private readonly HttpClient _httpClient;

        public InscripcionesService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<InscripcionViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("inscripciones");
            if (!response.IsSuccessStatusCode) return new List<InscripcionViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<InscripcionViewModel>>(apiResponse.data.ToString()) ?? new List<InscripcionViewModel>();
        }

        public async Task<InscripcionViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"inscripciones/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<InscripcionViewModel>(apiResponse.data.ToString());
        }

        public async Task<(bool Success, string? ErrorMessage)> CreateAsync(InscripcionViewModel inscripcion, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(inscripcion), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("inscripciones", content);
            
            if (response.IsSuccessStatusCode) return (true, null);
            
            var errorJson = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(errorJson);
            return (false, errorRes?.message?.ToString() ?? "Error interno del servidor");
        }

        public async Task<(bool Success, string? ErrorMessage)> UpdateAsync(int id, InscripcionViewModel inscripcion, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(inscripcion), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"inscripciones/{id}", content);
            
            if (response.IsSuccessStatusCode) return (true, null);
            
            var errorJson = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(errorJson);
            return (false, errorRes?.message?.ToString() ?? "Error interno del servidor");
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"inscripciones/{id}");
            return response.IsSuccessStatusCode;
        }
    }
}
