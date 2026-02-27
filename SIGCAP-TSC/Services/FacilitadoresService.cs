using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Facilitadores;

namespace SIGCAP_TSC.Services
{
    public class FacilitadoresService
    {
        private readonly HttpClient _httpClient;

        public FacilitadoresService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<FacilitadorViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("facilitadores");
            if (!response.IsSuccessStatusCode) return new List<FacilitadorViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<FacilitadorViewModel>>(apiResponse.data.ToString()) ?? new List<FacilitadorViewModel>();
        }

        public async Task<FacilitadorViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"facilitadores/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<FacilitadorViewModel>(apiResponse.data.ToString());
        }

        public async Task<bool> CreateAsync(FacilitadorViewModel facilitador, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(facilitador), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("facilitadores", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> UpdateAsync(int id, FacilitadorViewModel facilitador, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(facilitador), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"facilitadores/{id}", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"facilitadores/{id}");
            return response.IsSuccessStatusCode;
        }
    }
}
