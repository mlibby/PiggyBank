global using PiggyBank.Import.GnuCash;

namespace PiggyBank;

public interface ICommand
{
    IPiggyBankContext Context { get; }

    void Configure(string key, string value);
    void ImportAccounts(IGnuCashContext gnuCashContext);
    void ImportCommodities(IGnuCashContext gnuCashContext);
    void ImportTransactions(IGnuCashContext gnuCashContext);
}