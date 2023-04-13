namespace PiggyBank;

public interface ICommand
{
    IPiggyBankContext Context { get; }

    void Configure(string key, string value);
    void ImportGnuCashAccounts(IGnuCashContext gnuCashContext);
}