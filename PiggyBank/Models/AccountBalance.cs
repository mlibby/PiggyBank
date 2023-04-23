namespace PiggyBank.Models;

public partial class AccountBalance : Account
{
    public DateTime StartDate { get; set; } = DateTime.UtcNow;
    public DateTime EndDate { get; set; } = DateTime.UtcNow;
    public Decimal Balance { get; set; } = 0.0m;

    public new List<AccountBalance> Children = new List<AccountBalance>();

    public string BalanceDisplay
    {
        get
        {
            var balance = Math.Round(Balance, Commodity.Precision);
            if (this.Type == AccountType.Income)
            {
                balance = 0.0m - balance;
            }

            return string.Format("{0}{1:F2}", Commodity.Symbol, balance);
        }
    }
}
