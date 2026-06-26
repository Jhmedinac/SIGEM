namespace SIGCAP_TSC.Models.Auth
{
    public class LoginViewModel
    {
        public string Usuario { get; set; }
        public string Password { get; set; }
        public string AuthType { get; set; } = "ad";
    }
}