using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Personal;

namespace SIGCAP_TSC.Services
{
    public class PersonalService
    {
        private readonly HttpClient _httpClient;

        public PersonalService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<PersonalViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("personal");
            if (!response.IsSuccessStatusCode) return new List<PersonalViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<PersonalViewModel>>(apiResponse.data.ToString()) ?? new List<PersonalViewModel>();
        }

        public async Task<PersonalViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"personal/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<PersonalViewModel>(apiResponse.data.ToString());
        }

        public async Task<bool> CreateAsync(PersonalViewModel personal, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(personal), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("personal", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> UpdateAsync(int id, PersonalViewModel personal, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(personal), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"personal/{id}", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"personal/{id}");
            return response.IsSuccessStatusCode;
        }
    }
}
