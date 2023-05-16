using System.ComponentModel.DataAnnotations.Schema;

namespace PiggyBank.Models;

public partial class Account
{
    public static IEnumerable<ValidationWarning> Validate(List<Account> accounts)
    {
        var warnings = new List<ValidationWarning>();
        foreach (var account in accounts)
        {
            if (!account.IsPlaceholder && account.Children.Count > 0)
            {
                warnings.Add(new ValidationWarning(account, "Non-placeholder account may not have sub-accounts. Please move sub-accounts to a placeholder or mark account as a placeholder."));
            }
        }

        return warnings;
    }

    private string _FullName = null!;
    [NotMapped]
    public string FullName
    {
        get
        {
            if (string.IsNullOrWhiteSpace(_FullName))
            {
                var names = new List<string>() { Name };
                var account = this.Parent;
                while (account is object)
                {
                    names.Add(account.Name);
                    account = account.Parent;
                }

                names.Reverse();
                _FullName = string.Join(":", names);
            }

            return _FullName;
        }
    }
}

