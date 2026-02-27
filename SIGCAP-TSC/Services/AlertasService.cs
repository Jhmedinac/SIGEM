using Newtonsoft.Json;
using SIGCAP_TSC.Models.Alertas;

namespace SIGCAP_TSC.Services
{
    public class AlertasService
    {
        private readonly HttpClient _httpClient;

        public AlertasService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<AlertaViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("alertas");
            if (!response.IsSuccessStatusCode) return new List<AlertaViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<AlertaViewModel>>(apiResponse.data.ToString()) ?? new List<AlertaViewModel>();
        }

        public async Task<AlertaCount> GetCountAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("alertas/count");
            if (!response.IsSuccessStatusCode) return new AlertaCount();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<AlertaCount>(apiResponse.data.ToString()) ?? new AlertaCount();
        }
    }
}
