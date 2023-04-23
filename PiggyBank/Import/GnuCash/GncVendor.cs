namespace PiggyBank.Import.GnuCash;

public partial class GncVendor
{
    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Id { get; set; } = null!;

    public string Notes { get; set; } = null!;

    public string Currency { get; set; } = null!;

    public long Active { get; set; }

    public long TaxOverride { get; set; }

    public string? AddrName { get; set; }

    public string? AddrAddr1 { get; set; }

    public string? AddrAddr2 { get; set; }

    public string? AddrAddr3 { get; set; }

    public string? AddrAddr4 { get; set; }

    public string? AddrPhone { get; set; }

    public string? AddrFax { get; set; }

    public string? AddrEmail { get; set; }

    public string? Terms { get; set; }

    public string? TaxInc { get; set; }

    public string? TaxTable { get; set; }
}
