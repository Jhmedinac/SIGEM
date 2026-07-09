using Microsoft.AspNetCore.Authentication.Cookies;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var baseUrl = builder.Configuration.GetSection("ApiSettings:BaseUrl").Value;
if (!baseUrl.EndsWith("/")) { baseUrl += "/"; }

Action<HttpClient> configureClient = client =>
{
    client.BaseAddress = new Uri(baseUrl);
};

builder.Services.AddHttpClient<SIGCAP_TSC.Services.AuthService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.DashboardService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.EventosService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.SalonesService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.ParticipantesService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.UsuariosService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.AlertasService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.FacilitadoresService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.InscripcionesService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.AsistenciaService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.PersonalService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.GeograficoService>(configureClient);
builder.Services.AddHttpClient<SIGCAP_TSC.Services.CatalogosService>(configureClient);

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Auth/Login";
        options.LogoutPath = "/Auth/Logout";
        options.ExpireTimeSpan = TimeSpan.FromHours(8); // Match con JWT del backend
    });

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromHours(8); // Igual que el JWT del backend
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
}); // Para guardar el token temporalmente

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseMiddleware<SIGCAP_TSC.Middlewares.ExceptionHandlingMiddleware>();

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseSession();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Dashboard}/{action=Index}/{id?}");

app.MapGet("/", context =>
{
    context.Response.Redirect("/Dashboard/Index");
    return Task.CompletedTask;
});

app.Run();
