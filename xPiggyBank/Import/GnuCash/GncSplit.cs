namespace PiggyBank.Data.Import.GnuCash;

public partial class GncSplit
{
    public string Guid { get; set; } = null!;

    public string TransactionGuid { get; set; } = null!;

    public string AccountGuid { get; set; } = null!;

    public string Memo { get; set; } = null!;

    public string Action { get; set; } = null!;

    public string ReconcileState { get; set; } = null!;

    public string? ReconcileDate { get; set; }

    public long ValueNumber { get; set; }

    public long ValueDenomination { get; set; }

    public long QuantityNumber { get; set; }

    public long QuantityDenomination { get; set; }

    public string? LotGuid { get; set; }

    public virtual GncTransaction Transaction { get; set; } = null!;
}
