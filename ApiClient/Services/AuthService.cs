using Newtonsoft.Json;
using System.Text;
using ApiClient.Models.Auth;
namespace ApiClient.Services
{
    public class AuthService
    {
        private readonly HttpClient _httpClient;
        private readonly string _baseUrl;

        public AuthService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _baseUrl = configuration["ApiSettings:BaseUrl"];
        }

        public async Task<LoginResult> LoginAsync(string usuario, string password)
        {
            var loginData = new { usuario = usuario, password = password };
            var content = new StringContent(JsonConvert.SerializeObject(loginData), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync($"{_baseUrl}/auth/login", content);
                var jsonResult = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    // Intentar parsear el mensaje de error del API
                    dynamic errorResponse = JsonConvert.DeserializeObject(jsonResult);
                    string errorMessage = errorResponse?.message ?? "Error en el servidor";
                    return new LoginResult { Success = false, ErrorMessage = errorMessage };
                }

                var tokenResponse = JsonConvert.DeserializeObject<TokenResponse>(jsonResult);
                return new LoginResult { Success = true, Token = tokenResponse.AccessToken, RefreshToken = tokenResponse.RefreshToken };
            }
            catch (Exception ex)
            {
                return new LoginResult { Success = false, ErrorMessage = "Error de conexión: " + ex.Message };
            }
        }
    }

    public class LoginResult
    {
        public bool Success { get; set; }
        public string Token { get; set; }
        public string RefreshToken { get; set; }
        public string ErrorMessage { get; set; }
    }
}