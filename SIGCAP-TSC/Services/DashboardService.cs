using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Dashboard;

namespace SIGCAP_TSC.Services
{
    public class DashboardService
    {
        private readonly HttpClient _httpClient;
        private readonly string _baseUrl;

        public DashboardService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _baseUrl = configuration["ApiSettings:BaseUrl"];
        }

        public async Task<DashboardStatsViewModel> GetStatsAsync(string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
            var response = await _httpClient.GetAsync("dashboard/stats");

            if (!response.IsSuccessStatusCode)
            {
                return new DashboardStatsViewModel { LatestUsers = new List<DashboardUserViewModel>() };
            }

            var jsonResult = await response.Content.ReadAsStringAsync();
            dynamic apiResponse = JsonConvert.DeserializeObject(jsonResult);
            
            // Assuming standard response wrapper { status: "success", data: { ... } }
            var data = apiResponse.data;
            return JsonConvert.DeserializeObject<DashboardStatsViewModel>(data.ToString());
        }
    }
}
