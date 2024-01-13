namespace PiggyBank.Data.Models;

public partial class Commodity
{
    public string DisplayAmount(decimal amount, bool round = false)
    {
        var precision = round ? 0 : Precision;
        var roundedAmount = Math.Round(amount, precision);
        var spacer = (Symbol?.Length > 1) ? " " : "";
        {
            return string.Format("{0}{1}{2:N" + precision + "}", Symbol, spacer, roundedAmount);
        }
    }
}
