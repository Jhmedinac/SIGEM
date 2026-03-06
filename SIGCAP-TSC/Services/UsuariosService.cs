using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Usuarios;

namespace SIGCAP_TSC.Services
{
    public class UsuariosService
    {
        private readonly HttpClient _httpClient;

        public UsuariosService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        private void ConfigurarAuth(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        public async Task<List<UsuarioViewModel>> GetAllAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("usuarios");
            if (!response.IsSuccessStatusCode) return new List<UsuarioViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<UsuarioViewModel>>(apiResponse.data.ToString()) ?? new List<UsuarioViewModel>();
        }

        public async Task<UsuarioViewModel> GetByIdAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync($"usuarios/{id}");
            if (!response.IsSuccessStatusCode) return null;

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<UsuarioViewModel>(apiResponse.data.ToString());
        }

        public async Task<List<PersonaDisponibleViewModel>> GetPersonasDisponiblesAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("usuarios/personas-disponibles");
            if (!response.IsSuccessStatusCode) return new List<PersonaDisponibleViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<PersonaDisponibleViewModel>>(apiResponse.data.ToString()) ?? new List<PersonaDisponibleViewModel>();
        }

        public async Task<List<RolViewModel>> GetRolesAsync(string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.GetAsync("usuarios/roles");
            if (!response.IsSuccessStatusCode) return new List<RolViewModel>();

            var json = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<RolViewModel>>(apiResponse.data.ToString()) ?? new List<RolViewModel>();
        }

        public async Task<bool> CreateAsync(UsuarioViewModel usuario, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(usuario), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("usuarios", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> UpdateAsync(int id, UsuarioViewModel usuario, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(new { username = usuario.username, is_locked = usuario.is_locked, id_rol = usuario.id_rol }), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"usuarios/{id}", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> DeleteAsync(int id, string token)
        {
            ConfigurarAuth(token);
            var response = await _httpClient.DeleteAsync($"usuarios/{id}");
            return response.IsSuccessStatusCode;
        }

        public async Task<string> ResetPasswordAsync(int id, string newPassword, string token)
        {
            ConfigurarAuth(token);
            var data = new { nueva_password = newPassword };
            var content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
            var response = await _httpClient.PatchAsync($"usuarios/{id}/reset-password", content);
            
            if (response.IsSuccessStatusCode) return null;

            var jsonResult = await response.Content.ReadAsStringAsync();
            dynamic errorResponse = JsonConvert.DeserializeObject(jsonResult);
            return errorResponse?.message ?? "Error en el servidor";
        }

         public async Task<bool> ToggleLockAsync(int id, bool isLocked, string token)
        {
            ConfigurarAuth(token);
            var data = new { is_locked = isLocked };
            var content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
            var response = await _httpClient.PatchAsync($"usuarios/{id}/toggle-lock", content);
            return response.IsSuccessStatusCode;
        }
    }
}
