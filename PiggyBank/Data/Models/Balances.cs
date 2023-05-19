namespace PiggyBank.Data.Models;

public class Balances
{
    private readonly Dictionary<Guid, Decimal> _Balances = new();

    public DateOnly StartDate { get; }
    public DateOnly EndDate { get; }

    /// <summary>
    /// Calculates balances for all accounts in the tree
    /// </summary>
    /// <param name="accounts">A tree of accounts, must have one record with a null parent ID to work</param>
    /// <param name="startDate">the earliest date of transaction to include</param>
    /// <param name="endDate">the last date of transaction to include</param>
    public Balances(IEnumerable<Account> accounts, DateOnly startDate, DateOnly endDate)
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
        get => _Balances.ContainsKey(accountId) ? _Balances[accountId] : 0.0M;
        set => _Balances[accountId] = value;
    }

    private void CalculateBalance(Account account)
    {
        var splits = account.Splits
            .Where(s =>
                s.Transaction.PostDate >= StartDate &&
                s.Transaction.PostDate <= EndDate &&
                !s.Transaction.Description.ToLower().StartsWith("close books"))
            .ToList();
        var balance = splits.Sum(s => s.Value);

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
