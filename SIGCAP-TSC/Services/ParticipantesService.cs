using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Participantes;

namespace SIGCAP_TSC.Services
{
    public class ParticipantesService
    {
        private readonly HttpClient _httpClient;

        public ParticipantesService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<ParticipanteViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("participantes");
            if (!response.IsSuccessStatusCode) return new List<ParticipanteViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<ParticipanteViewModel>>(apiResponse.data.ToString()) ?? new List<ParticipanteViewModel>();
        }

        public async Task<ParticipanteViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"participantes/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<ParticipanteViewModel>(apiResponse.data.ToString());
        }

        public async Task<(bool Success, string? ErrorMessage)> CreateAsync(ParticipanteViewModel participante, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(participante), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("participantes", content);

            if (response.IsSuccessStatusCode) return (true, null);

            var errorJson = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(errorJson);
            return (false, errorRes?.message?.ToString() ?? "Error al crear el participante.");
        }

        public async Task<(bool Success, string? ErrorMessage)> UpdateAsync(int id, ParticipanteViewModel participante, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(participante), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"participantes/{id}", content);

            if (response.IsSuccessStatusCode) return (true, null);

            var errorJson = await response.Content.ReadAsStringAsync();
            dynamic? errorRes = JsonConvert.DeserializeObject(errorJson);
            return (false, errorRes?.message?.ToString() ?? "Error al actualizar el participante.");
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"participantes/{id}");
            return response.IsSuccessStatusCode;
        }
    }
}
