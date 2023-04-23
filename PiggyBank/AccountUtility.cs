namespace PiggyBank
{
    public class AccountUtility
    {
        private IPiggyBankContext PiggyBankContext { get; }

        public AccountUtility(IPiggyBankContext piggyBankContext)
        {
            PiggyBankContext = piggyBankContext;
        }

        public List<AccountBalance> GetAccountBalances(List<Account> accounts, DateTime startDate, DateTime endDate)
        {
            var accountBalancesDictionary = new Dictionary<Guid, AccountBalance>();

            // Create an account balance for each account
            foreach (var account in accounts)
            {
                CloneAccountIntoDictionary(account, startDate, endDate, accountBalancesDictionary);
            }

            // Recreate the child relationships
            foreach (var (id, accountBalance) in accountBalancesDictionary)
            {
                if (accountBalance.ParentId.HasValue)
                {
                    var parent = accountBalancesDictionary[accountBalance.ParentId.Value];
                    parent.Children.Add(accountBalance);
                    parent.Balance += accountBalance.Balance;
                }
            }

            // Build account tree
            var accountBalances = new List<AccountBalance>();
            foreach (var account in accounts.Where(a => a.Parent is null))
            {
                accountBalances.Add(accountBalancesDictionary[account.Id]);
            }

            return accountBalances;
        }

        private static void CloneAccountIntoDictionary(Account account, DateTime startDate, DateTime endDate, Dictionary<Guid, AccountBalance> accountBalancesDictionary)
        {
            var ab = new AccountBalance
            {
                Id = account.Id,
                Name = account.Name,
                Commodity = account.Commodity,
                Description = account.Description,
                IsHidden = account.IsHidden,
                IsPlaceholder = account.IsPlaceholder,
                ParentId = account.ParentId,
                Type = account.Type,
                StartDate = startDate,
                EndDate = endDate,
                Balance = account.Splits
                    .Where(s => s.Transaction.PostDate >= startDate && s.Transaction.PostDate <= endDate)
                    .Sum(s => s.Value),
            };
            accountBalancesDictionary.Add(account.Id, ab);
        }
    }
}
