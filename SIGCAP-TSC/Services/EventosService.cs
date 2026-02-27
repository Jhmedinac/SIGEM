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
            dynamic apiResponse = JsonConvert.DeserializeObject(json);
            return JsonConvert.DeserializeObject<List<EventoViewModel>>(apiResponse.data.ToString()) ?? new List<EventoViewModel>();
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

        public async Task<bool> CreateAsync(EventoViewModel evento, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(evento), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("eventos", content);
            return response.IsSuccessStatusCode;
        }

        public async Task<bool> UpdateAsync(int id, EventoViewModel evento, string token)
        {
            ConfigurarAuth(token);
            var content = new StringContent(JsonConvert.SerializeObject(evento), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"eventos/{id}", content);
            return response.IsSuccessStatusCode;
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
    }
}
