using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using PiggyBank.Areas.Identity;
using PiggyBank.Data.Import.GnuCash;

namespace PiggyBank;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        var piggyBankConnection = builder.Configuration.GetConnectionString("PiggyBankConnection") ?? throw new InvalidOperationException("Connection string 'PiggyBankConnection' not found.");
        builder.Services.AddDbContext<PiggyBankContext>(options =>
            options.UseSqlite(piggyBankConnection));
        var gnuCashConnection = builder.Configuration.GetConnectionString("GnuCashConnection") ?? throw new InvalidOperationException("Connection string 'GnuCashConnection' not found.");
        builder.Services.AddDbContext<GnuCashContext>(options =>
            options.UseSqlite(gnuCashConnection));
        builder.Services.AddDatabaseDeveloperPageExceptionFilter();
        builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
            .AddEntityFrameworkStores<PiggyBankContext>();
        builder.Services.AddRazorPages();
        builder.Services.AddServerSideBlazor();

        builder.Services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();
        builder.Services.AddScoped<AccountService, AccountService>();
        builder.Services.AddScoped<CommodityService, CommodityService>();
        builder.Services.AddScoped<ImportService, ImportService>();

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
    }
}