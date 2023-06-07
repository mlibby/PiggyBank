namespace PiggyBank.Data.Models;

public partial class Commodity
{
    public string DisplayAmount(decimal amount, bool round = false)
    {
        var precision = round ? 0 : Precision;
        var roundedAmount = Math.Round(amount, precision);
        return string.Format("{0}{1:N" + precision + "}", Symbol, roundedAmount);
    }
}
