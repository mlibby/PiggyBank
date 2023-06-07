var builder = WebApplication.CreateBuilder(args);

builder.WebHost.UseWebRoot("wwwroot").UseStaticWebAssets();

var services = builder.Services;

// Add services to the container.
var piggyBankConnection = builder.Configuration.GetConnectionString("PiggyBankConnection") ??
    throw new InvalidOperationException("Connection string 'PiggyBankConnection' not found.");
services.AddDbContext<PiggyBankContext>(options =>
            options.UseSqlite(piggyBankConnection), ServiceLifetime.Transient);

var gnuCashConnection = builder.Configuration.GetConnectionString("GnuCashConnection") ??
    throw new InvalidOperationException("Connection string 'GnuCashConnection' not found.");
services.AddDbContext<GnuCashContext>(options =>
            options.UseSqlite(gnuCashConnection), ServiceLifetime.Transient);

services.AddDatabaseDeveloperPageExceptionFilter();
services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<PiggyBankContext>();

services.AddRazorPages();
services.AddServerSideBlazor();

services
    .AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();

services
    .AddScoped<PiggyBankService, PiggyBankService>()
    .AddScoped<ImportService, ImportService>()
    .AddScoped<NotificationService, NotificationService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapControllers();
app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
