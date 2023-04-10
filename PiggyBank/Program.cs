using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using PiggyBank.Models;
using System;

namespace PiggyBank
{
    internal class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 3) { return; }

            if (args[0] == "import")
            {
                if (args[1] == "gnucash")
                {
                    if (args[2] == "accounts")
                    {

                    }
                }
            }

            if (args[0] == "config")
            {
                if (args[1] == "gnucash-db")
                {
                    var command = new Command(
                }
            }
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
                    options.UseSqlServer(connectionString: connectionString);
                });
            });
        }
    }
}