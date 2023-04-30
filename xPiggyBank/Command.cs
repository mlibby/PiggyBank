using PiggyBank.Data.Import.GnuCash;

namespace PiggyBank;

public class Command : ICommand
{
    public IPiggyBankContext Context { get; }

    public Command(IPiggyBankContext context)
    {
        Context = context;
    }

    public void Configure(string key, string value)
    {
        var config = Context.Configurations.SingleOrDefault(x => x.Key == key);
        if (config is object)
        {
            config.Value = value;
        }
        else
        {
            config = new Configuration
            {
                Key = key,
                Value = value
            };
            Context.Configurations.Add(config);
        }

        Context.SaveChanges();
    }

    public void ImportAccounts(IGnuCashContext gnuCashContext)
    {
        var importer = new Data.Import.GnuCash.Importer(gnuCashContext, Context);
        importer.ImportAccounts();
    }

    public void ImportCommodities(IGnuCashContext gnuCashContext)
    {
        var importer = new Data.Import.GnuCash.Importer(gnuCashContext, Context);
        importer.ImportCommodities();
    }

    public void ImportTransactions(IGnuCashContext gnuCashContext)
    {
        var importer = new Data.Import.GnuCash.Importer(gnuCashContext, Context);
        importer.ImportTransactions();
    }
}