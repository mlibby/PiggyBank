namespace PiggyBank.Models;

public partial class PiggyBankContext : DbContext, IPiggyBankContext
{
    public PiggyBankContext(DbContextOptions<PiggyBankContext> options) : base(options) { }

    public virtual DbSet<Account> Accounts { get; set; } = null!;

    public virtual DbSet<Commodity> Commodities { get; set; } = null!;

    public virtual DbSet<Configuration> Configurations { get; set; } = null!;

    public virtual DbSet<ExternalId> ExternalIds { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Accounts");

            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.Type).HasConversion(
                v => v.ToString(),
                v => (Account.AccountType)Enum.Parse(typeof(Account.AccountType), v));

            entity.HasOne(d => d.Commodity).WithMany()
                .HasForeignKey(d => d.CommodityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Accounts_Commodities");

            entity.HasOne(d => d.Parent).WithMany(p => p.Children)
                .HasForeignKey(d => d.ParentId)
                .HasConstraintName("FK_Accounts_Accounts");
        });

        modelBuilder.Entity<Commodity>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Commodities");

            entity.Property(e => e.Cusip).HasMaxLength(255);
            entity.Property(e => e.Mnemonic).HasMaxLength(255);
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.Symbol).HasMaxLength(16);
            entity.Property(e => e.Type).HasConversion(
                v => v.ToString(),
                v => (Commodity.CommodityType)Enum.Parse(typeof(Commodity.CommodityType), v));
        });

        modelBuilder.Entity<Configuration>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Configuration");

            entity.Property(e => e.Id);
            entity.Property(e => e.Key)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Value)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ExternalId>(entity =>
        {
            entity.HasIndex(e => new { e.LocalId, e.Source, e.Type }, "UX_LocalIDSourceType").IsUnique();

            entity.Property(e => e.ExternalIdString)
                .HasMaxLength(255)
                .HasColumnName("ExternalId");
            entity.Property(e => e.Type).HasConversion(
                v => v.ToString(),
                v => (ExternalId.IdType)Enum.Parse(typeof(ExternalId.IdType), v));
            entity.Property(e => e.Source).HasConversion(
                v => v.ToString(),
                v => (ExternalId.SourceType)Enum.Parse(typeof(ExternalId.SourceType), v));
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
