namespace PiggyBankWeb.Models
{
    public class BalancesViewModel
    {
        public IEnumerable<Account> Accounts { get; }
        public AccountBalances Balances { get; }

        public BalancesViewModel(IEnumerable<Account> accounts, AccountBalances balances)
        {
            Accounts = accounts;
            Balances = balances;
        }
    }
}
