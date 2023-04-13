namespace PiggyBank.Models;

public partial class Configuration
{
    public const string GnuCashDbKey = "gnucash-db";

    public static List<string> ConfigurationNames = new List<string> { GnuCashDbKey };

    public int Id { get; set; }

    public string Key { get; set; } = null!;

    public string Value { get; set; } = null!;
}