namespace PiggyBank;

public class CommandLine
{
    private const string _Accounts = "accounts";
    private const string _Commodities = "commodities";
    private const string _Config = "config";
    private const string _Import = "import";
    private const string _GnuCash = "gnucash";
    private const string _Transactions = "transactions";

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
                var gnuCashContext = GetGnuCashContext(Command.Context);

                if (args[2] == _Transactions)
                {
                    Command.ImportTransactions(gnuCashContext);
                }

                if (args[2] == _Commodities)
                {
                    Command.ImportCommodities(gnuCashContext);
                    return;
                }

                if (args[2] == _Accounts)
                {
                    Command.ImportAccounts(gnuCashContext);
                    return;
                }

                Console.WriteLine($"{args[2]} is not a valid GnuCash import");
            }

            Console.WriteLine($"{args[1]} is not a valid import target");
            return;
        }

        if (args[0] == _Config)
        {
            if (!Configuration.ConfigurationKeys.Contains(args[1]))
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
