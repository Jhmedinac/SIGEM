using Microsoft.AspNetCore.Authentication.Cookies;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var baseUrl = builder.Configuration.GetSection("ApiSettings:BaseUrl").Value;
if (!baseUrl.EndsWith("/")) { baseUrl += "/"; }

builder.Services.AddHttpClient<SIGCAP_TSC.Services.AuthService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.DashboardService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.EventosService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.SalonesService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.ParticipantesService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.UsuariosService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.AlertasService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});
builder.Services.AddHttpClient<SIGCAP_TSC.Services.FacilitadoresService>(client => 
{
    client.BaseAddress = new Uri(baseUrl);
});

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Auth/Login";
        options.LogoutPath = "/Auth/Logout";
        options.ExpireTimeSpan = TimeSpan.FromHours(8); // Match con JWT del backend
    });

builder.Services.AddSession(); // Para guardar el token temporalmente

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

app.MapGet("/", context => {
    context.Response.Redirect("/Dashboard/Index");
    return Task.CompletedTask;
});

app.Run();
