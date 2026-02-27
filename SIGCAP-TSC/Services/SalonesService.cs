using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Salones;

namespace SIGCAP_TSC.Services
{
    public class SalonesService
    {
        private readonly HttpClient _httpClient;

        public SalonesService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<SalonViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("salones");
            if (!response.IsSuccessStatusCode) return new List<SalonViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<SalonViewModel>>(apiResponse.data.ToString()) ?? new List<SalonViewModel>();
        }

        public async Task<SalonViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"salones/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<SalonViewModel>(apiResponse.data.ToString());
        }

        public async Task<bool> CreateAsync(SalonViewModel salon, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(salon), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("salones", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> UpdateAsync(int id, SalonViewModel salon, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(salon), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"salones/{id}", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"salones/{id}");
            return response.IsSuccessStatusCode;
        }
    }
}
