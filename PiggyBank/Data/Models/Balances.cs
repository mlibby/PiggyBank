﻿namespace PiggyBank.Data.Models;

public class Balances
{
    private readonly Dictionary<Guid, decimal> _balances = new();

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
    public decimal this[Guid accountId]
    {
        get => _balances.TryGetValue(accountId, out var balance) ? balance : 0.0M;
        set => _balances[accountId] = value;
    }

    public bool TryGetValue(Guid accountId, out decimal balance) => _balances.TryGetValue(accountId, out balance);

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
            balance += _balances[childAccount.Id];
        }

        _balances.Add(account.Id, balance);
    }
}
