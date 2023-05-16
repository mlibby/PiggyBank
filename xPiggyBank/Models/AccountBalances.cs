namespace PiggyBank.Models
{
    public class AccountBalances
    {
        private Dictionary<Guid, Decimal> _Balances = new Dictionary<Guid, Decimal>();

        public DateTime StartDate { get; }
        public DateTime EndDate { get; }

        public AccountBalances(IEnumerable<Account> accounts, DateTime startDate, DateTime endDate)
        {
            StartDate = startDate;
            EndDate = endDate;
            foreach (var rootAccount in accounts.Where(a => a.ParentId == null))
            {
                CalculateBalance(rootAccount);
            }
        }
        public Decimal this[Guid accountId]
        {
            get { return _Balances[accountId]; }
        }

        private void CalculateBalance(Account account)
        {
            var balance = account.Splits
                .Where(s => s.Transaction.PostDate >= StartDate && s.Transaction.PostDate <= EndDate)
                .Sum(s => s.Value);

            if (account.Type == Account.AccountType.Income)
            {
                balance = -balance;
            }

            foreach (var childAccount in account.Children)
            {
                CalculateBalance(childAccount);
                balance += _Balances[childAccount.Id];
            }

            _Balances.Add(account.Id, balance);
        }
    }
}
