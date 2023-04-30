using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using PiggyBankWeb.Data;

namespace PiggyBankWeb
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            var dbContextToUse = builder.Configuration.GetValue("dbProvider", "Sqlite");

            //if (dbContextToUse == "SqlServer")
            //{
            //    var connectionString = builder.Configuration.GetConnectionString("PiggyBankSqlServerContext") ?? throw new InvalidOperationException("Connection string 'PiggyBankSqlServerContext' not found.");
            //    builder.Services.AddDbContext<ApplicationDbContext>(options =>
            //        options.UseSqlServer(connectionString));
            //    builder.Services.AddDbContext<PiggyBankContext>(options =>
            //        options.UseSqlServer(connectionString));
            //}
            //else
            //{
            var connectionString = builder.Configuration.GetConnectionString("PiggyBankContext") ?? throw new InvalidOperationException("Connection string 'PiggyBankSqliteContext' not found.");
            builder.Services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlite(connectionString));
            builder.Services.AddDbContext<PiggyBankContext>(options =>
                options.UseSqlite(connectionString));
            //}

            builder.Services.AddDatabaseDeveloperPageExceptionFilter();

            builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
                .AddEntityFrameworkStores<ApplicationDbContext>();
            builder.Services.AddControllersWithViews();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseMigrationsEndPoint();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");
            app.MapRazorPages();

            app.Run();
        }

        static IHostBuilder CreateHostBuilder(string[] args)
        {
            return Host.CreateDefaultBuilder(args).ConfigureServices(services =>
            {
                services.AddDbContext<PiggyBankContext>(options =>
                {
                    IConfigurationRoot configuration = new ConfigurationBuilder()
                        .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                        .AddJsonFile("appsettings.json")
                        .Build();
                    var connectionString = configuration.GetConnectionString("PiggyBankContext");
                    options.UseSqlite(connectionString);
                });
            });
        }
    }
}