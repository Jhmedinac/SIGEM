using Newtonsoft.Json;
using System.Text;
using SIGCAP_TSC.Models.Auth;
namespace SIGCAP_TSC.Services
{
    public class AuthService
    {
        private readonly HttpClient _httpClient;

        public AuthService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
        }

        public async Task<LoginResult> LoginAsync(string usuario, string password)
        {
            var loginData = new { username = usuario, password = password };
            var content = new StringContent(JsonConvert.SerializeObject(loginData), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("auth/login", content);
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
        public async Task<AuthResult> ForgotPasswordAsync(string email)
        {
            var data = new { email = email };
            var content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("auth/forgot-password", content);
                var jsonResult = await response.Content.ReadAsStringAsync();
                Console.WriteLine(jsonResult);
                if (!response.IsSuccessStatusCode)
                {
                    dynamic errorResponse = JsonConvert.DeserializeObject(jsonResult);
                    string errorMessage = errorResponse?.message ?? "Error en el servidor al enviar email.";
                    return new AuthResult { Success = false, ErrorMessage = errorMessage };
                }

                return new AuthResult { Success = true };
            }
            catch (Exception ex)
            {
                return new AuthResult { Success = false, ErrorMessage = "Error de conexión: " + ex.Message };
            }
        }

        public async Task<AuthResult> ResetPasswordAsync(string token, string newPassword)
        {
            var data = new { token = token, newPassword = newPassword };
            var content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("auth/reset-password", content);
                var jsonResult = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    dynamic errorResponse = JsonConvert.DeserializeObject(jsonResult);
                    string errorMessage = errorResponse?.message ?? "Error en el servidor al actualizar contraseña.";
                    return new AuthResult { Success = false, ErrorMessage = errorMessage };
                }

                return new AuthResult { Success = true };
            }
            catch (Exception ex)
            {
                return new AuthResult { Success = false, ErrorMessage = "Error de conexión: " + ex.Message };
            }
        }
        public async Task<(bool Success, string Message)> ChangePasswordAsync(string actual, string nueva, string token)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
            var content = new StringContent(JsonConvert.SerializeObject(new { actual = actual, nueva = nueva }), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("usuarios/cambiar-password", content);
                var resultString = await response.Content.ReadAsStringAsync();
                dynamic jsonResponse = JsonConvert.DeserializeObject(resultString);

                if (response.IsSuccessStatusCode)
                {
                    return (true, "Contraseña actualizada correctamente");
                }

                return (false, jsonResponse?.message?.ToString() ?? "Error al cambiar la contraseña");
            }
            catch (Exception ex)
            {
                return (false, "Error de conexión: " + ex.Message);
            }
        }
    }

    public class AuthResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
    }

    public class LoginResult
    {
        public bool Success { get; set; }
        public string Token { get; set; }
        public string RefreshToken { get; set; }
        public string ErrorMessage { get; set; }
    }
}