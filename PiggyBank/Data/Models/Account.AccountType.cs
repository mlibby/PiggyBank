namespace PiggyBank.Data.Models;

public partial class Account
{
    public enum AccountType
    {
        Asset,
        Equity,
        Expense,
        Income,
        Liability,
    }
}

