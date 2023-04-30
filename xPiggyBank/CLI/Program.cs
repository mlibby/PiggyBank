//using Microsoft.Extensions.Configuration;
//using Microsoft.Extensions.DependencyInjection;
//using Microsoft.Extensions.Hosting;

//namespace PiggyBank;

//internal class Program
//{
//    static void Main(string[] args)
//    {
//        var command = GetCommand();
//        var console = new Console();
//        var commandLine = new CommandLine(command, console);
//        commandLine.Main(args);
//    }

//    static private ICommand GetCommand()
//    {
//        return new Command(GetPiggyBankContext());
//    }

//    static private IPiggyBankContext GetPiggyBankContext()
//    {
//        var connectionString = GetConnectionString();
//        if (!string.IsNullOrEmpty(connectionString))
//        {
//            return new PiggyBankContext(connectionString);
//        }
//        else
//        {
//            throw new Exception("Could not get PiggyBankContext connection string");
//        }
//    }

//    static private string GetConnectionString()
//    {
//        var builder = new ConfigurationBuilder()
//            .SetBasePath(System.IO.Directory.GetCurrentDirectory())
//            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
//        var configuration = builder.Build();
//        return configuration.GetConnectionString("PiggyBankContext")!;
//    }

//    static IHostBuilder CreateHostBuilder(string[] args)
//    {
//        return Host.CreateDefaultBuilder(args).ConfigureServices(services =>
//        {
//            services.AddDbContext<PiggyBankContext>(options =>
//            {
//                IConfigurationRoot configuration = new ConfigurationBuilder()
//                    .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
//                    .AddJsonFile("appsettings.json")
//                    .Build();
//                var connectionString = configuration.GetConnectionString("PiggyBankContext");

//                options.UseSqlite("X:\\Financial\\piggybank.db");
//                //                options.UseSqlServer(connectionString: connectionString);
//            });
//        });
//    }
//}