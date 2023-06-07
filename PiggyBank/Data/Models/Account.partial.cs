namespace PiggyBank.Data.Models;

public partial class Account
{
    private static Dictionary<AccountType, decimal> s_displayMultiplier = new()
    {
        { AccountType.Asset, 1.0m },
        { AccountType.Equity, -1.0m },
        { AccountType.Expense, -1.0m },
        { AccountType.Income, 1.0m },
        { AccountType.Liability, -1.0m }
    };

    private string _fullName = null!;
    [NotMapped]
    public string FullName
    {
        get
        {
            if (string.IsNullOrWhiteSpace(_fullName))
            {
                var names = new List<string>() { Name };
                var account = Parent;
                while (account is not null)
                {
                    names.Add(account.Name);
                    account = account.Parent;
                }

                names.Reverse();
                _fullName = string.Join(":", names);
            }

            return _fullName;
        }
    }

    public static IEnumerable<ValidationWarning> Validate(List<Account> accounts)
    {
        var warnings = new List<ValidationWarning>();
        foreach (var account in accounts)
        {
            if (!account.IsPlaceholder && account.Children.Count > 0)
            {
                warnings.Add(new ValidationWarning(
                    account,
                    "Non-placeholder account may not have sub-accounts. Please move sub-accounts to a placeholder or mark account as a placeholder."));
            }
        }

        return warnings;
    }

    public string DisplayAmount(decimal amount, bool round = false)
    {
        amount = s_displayMultiplier[AccountType] * amount;
        return Commodity.DisplayAmount(amount, round);
    }
}
