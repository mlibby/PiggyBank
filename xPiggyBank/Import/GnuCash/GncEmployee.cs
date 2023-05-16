namespace PiggyBank.Data.Import.GnuCash;

public partial class GncEmployee
{
    public string Guid { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string Id { get; set; } = null!;

    public string Language { get; set; } = null!;

    public string Acl { get; set; } = null!;

    public long Active { get; set; }

    public string Currency { get; set; } = null!;

    public string? CcardGuid { get; set; }

    public long WorkdayNum { get; set; }

    public long WorkdayDenom { get; set; }

    public long RateNum { get; set; }

    public long RateDenom { get; set; }

    public string? AddrName { get; set; }

    public string? AddrAddr1 { get; set; }

    public string? AddrAddr2 { get; set; }

    public string? AddrAddr3 { get; set; }

    public string? AddrAddr4 { get; set; }

    public string? AddrPhone { get; set; }

    public string? AddrFax { get; set; }

    public string? AddrEmail { get; set; }
}
