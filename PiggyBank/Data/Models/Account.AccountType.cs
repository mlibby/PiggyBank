namespace PiggyBank.Data.Models;

public partial class Account
{
    public enum AccountType
    {
        Asset = 1,
        Equity = 2,
        Expense = 3,
        Income = 4,
        Liability = 5,
        Invalid = 6
    }
}
