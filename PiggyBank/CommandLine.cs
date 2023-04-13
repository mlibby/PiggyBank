namespace PiggyBank;

public class CommandLine
{
    private const string _Accounts = "accounts";
    private const string _Config = "config";
    private const string _Import = "import";
    private const string _GnuCash = "gnucash";

    private ICommand Command { get; }
    private IConsole Console { get; }

    static private IGnuCashContext GetGnuCashContext(IPiggyBankContext piggyBankContext)
    {
        var gnuCashDbConfig = piggyBankContext.Configurations.Single(c => c.Key == Configuration.GnuCashDbKey).Value;
        var gnuCashDbConnection = $"Data Source={gnuCashDbConfig};Cache=Shared";
        return new GnuCashContext(gnuCashDbConnection);
    }

    public CommandLine(ICommand command, IConsole console)
    {
        Command = command;
        Console = console;
    }

    public void Main(string[] args)
    {
        if (args.Length == 0)
        {
            Console.WriteLine("Usage: `PiggyBank.exe [import|config] [subcommand1] [subcommand2]`");
            return;
        }

        if (args[0] == _Import)
        {
            if (args[1] == _GnuCash)
            {
                if (args[2] == _Accounts)
                {
                    var gnuCashContext = GetGnuCashContext(Command.Context);
                    Command.ImportGnuCashAccounts(gnuCashContext);
                    return;
                }

                Console.WriteLine($"{args[2]} is not a valid GnuCash import");
            }

            Console.WriteLine($"{args[1]} is not a valid import target");
            return;
        }

        if (args[0] == _Config)
        {
            if (!Configuration.ConfigurationNames.Contains(args[1]))
            {
                Console.WriteLine($"Invalid configuration {args[1]}");
                return;
            }

            Command.Configure(args[1], args[2]);
            return;
        }

        Console.WriteLine($"'{args[0]}' is not a valid command");
    }
}
