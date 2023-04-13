namespace PiggyBank.Import.GnuCash;

public partial class Transaction
{
    public string Guid { get; set; } = null!;

    public string CurrencyGuid { get; set; } = null!;

    public string Number { get; set; } = null!;

    public string? PostDate { get; set; }

    public string? EnterDate { get; set; }

    public string? Description { get; set; }
}
