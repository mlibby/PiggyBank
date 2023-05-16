namespace PiggyBank.Models;

public partial class Commodity
{
    public string DisplayAmount(decimal amount)
    {
        var roundedAmount = Math.Round(amount, Precision);
        return string.Format("{0}{1:N2}", Symbol, roundedAmount);
    }
}
