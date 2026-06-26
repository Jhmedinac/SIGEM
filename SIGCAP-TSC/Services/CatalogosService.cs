using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Catalogos;

namespace SIGCAP_TSC.Services
{
    public class CatalogosService
    {
        private readonly HttpClient _httpClient;

        public CatalogosService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<CargoViewModel>> GetCargosAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("catalogos/cargos");
            if (!response.IsSuccessStatusCode) return new List<CargoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return new List<CargoViewModel>();

            return JsonConvert.DeserializeObject<List<CargoViewModel>>(apiResponse.data.ToString()) ?? new List<CargoViewModel>();
        }

        public async Task<List<DireccionViewModel>> GetDireccionesAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("catalogos/direcciones");
            if (!response.IsSuccessStatusCode) return new List<DireccionViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return new List<DireccionViewModel>();

            return JsonConvert.DeserializeObject<List<DireccionViewModel>>(apiResponse.data.ToString()) ?? new List<DireccionViewModel>();
        }

        public async Task<List<DepartamentoViewModel>> GetDepartamentosAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("catalogos/departamentos");
            if (!response.IsSuccessStatusCode) return new List<DepartamentoViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic? apiResponse = JsonConvert.DeserializeObject(json);
            if (apiResponse == null || apiResponse.data == null) return new List<DepartamentoViewModel>();

            return JsonConvert.DeserializeObject<List<DepartamentoViewModel>>(apiResponse.data.ToString()) ?? new List<DepartamentoViewModel>();
        }
    }
}
