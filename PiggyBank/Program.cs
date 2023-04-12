using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace PiggyBank
{
    internal class Program
    {
        private static List<string> validCommands = new List<string> { "import", "config" };
        private static List<string> validConfigurations = new List<string> { "gnucash-db" };

        static void Main(string[] args)
        {
            if (args.Length != 3) { return; }

            if (!validCommands.Contains(args[0]))
            {
                Console.WriteLine($"{args[0]} is not a valid command");
                return;
            }

            if (args[0] == "import")
            {
                if (args[1] == "gnucash")
                {
                    if (args[2] == "accounts")
                    {
                        var command = GetCommand();
                        var gnuCashContext = GetGnuCashContext(command.Context);
                        command.ImportGnuCashAccounts(gnuCashContext);
                    }
                }
            }

            if (args[0] == "config")
            {
                if (!validConfigurations.Contains(args[1]))
                {
                    Console.WriteLine($"Invalid configuration {args[1]}");
                    return;
                }

                if (args[1] == "gnucash-db")
                {
                    var command = GetCommand();
                    command.Configure("gnucash-db", args[2]);
                }
            }
        }

        static private Command GetCommand()
        {
            return new Command(GetPiggyBankContext());
        }

        static private IGnuCashContext GetGnuCashContext(IPiggyBankContext piggyBankContext)
        {
            var gnuCashDbConfig = piggyBankContext.Configurations.Single(c => c.Key == "gnucash-db").Value;
            var gnuCashDbConnection = $"Data Source={gnuCashDbConfig};Cache=Shared";
            return new GnuCashContext(gnuCashDbConnection);
        }

        static private IPiggyBankContext GetPiggyBankContext()
        {
            var connectionString = GetConnectionString();
            if (!string.IsNullOrEmpty(connectionString))
            {
                return new PiggyBankContext(connectionString);
            }
            else
            {
                throw new Exception("Could not get PiggyBankContext connection string");
            }
        }

        static private string GetConnectionString()
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();
            return configuration.GetConnectionString("PiggyBankContext")!;
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