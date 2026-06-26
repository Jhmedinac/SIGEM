using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Geografico;

namespace SIGCAP_TSC.Services
{
    public class GeograficoService
    {
        private readonly HttpClient _httpClient;

        public GeograficoService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        // Fetch all active records
        public async Task<List<GeograficoViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("geografico");
            if (!response.IsSuccessStatusCode) return new List<GeograficoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return new List<GeograficoViewModel>();
            
            return JsonConvert.DeserializeObject<List<GeograficoViewModel>>(apiResponse.data.ToString()) ?? new List<GeograficoViewModel>();
        }

        // Fetch only departments (nivel = 1)
        public async Task<List<GeograficoViewModel>> GetDepartamentosAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("geografico/departamentos");
            if (!response.IsSuccessStatusCode) return new List<GeograficoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return new List<GeograficoViewModel>();

            return JsonConvert.DeserializeObject<List<GeograficoViewModel>>(apiResponse.data.ToString()) ?? new List<GeograficoViewModel>();
        }

        // Fetch municipalities of a specific department (nivel = 2)
        public async Task<List<GeograficoViewModel>> GetMunicipiosAsync(int departamentoId, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"geografico/departamentos/{departamentoId}/municipios");
            if (!response.IsSuccessStatusCode) return new List<GeograficoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return new List<GeograficoViewModel>();

            return JsonConvert.DeserializeObject<List<GeograficoViewModel>>(apiResponse.data.ToString()) ?? new List<GeograficoViewModel>();
        }

        // Fetch single entry by geographic code
        public async Task<GeograficoViewModel?> GetByCodigoAsync(int codigo, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"geografico/{codigo}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return null;

            return JsonConvert.DeserializeObject<GeograficoViewModel>(apiResponse.data.ToString());
        }
    }
}
