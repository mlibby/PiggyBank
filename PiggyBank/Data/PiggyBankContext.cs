﻿namespace PiggyBank.Data;

public class PiggyBankContext : IdentityDbContext
{
    public PiggyBankContext(DbContextOptions<PiggyBankContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; } = null!;
    public virtual DbSet<BudgetAmount> BudgetAmounts { get; set; } = null!;
    public virtual DbSet<Budget> Budgets { get; set; } = null!;
    public virtual DbSet<Commodity> Commodities { get; set; } = null!;
    public virtual DbSet<Setting> Settings { get; set; } = null!;
    public virtual DbSet<Price> Prices { get; set; } = null!;
    public virtual DbSet<Split> Splits { get; set; } = null!;
    public virtual DbSet<Transaction> Transactions { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.Updated).HasColumnType("datetime");

            entity.HasOne(d => d.Commodity).WithMany()
                .HasForeignKey(d => d.CommodityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Accounts_Commodities");

            entity.HasOne(d => d.Parent).WithMany(p => p.Children)
                .HasForeignKey(d => d.ParentId)
                .HasConstraintName("FK_Accounts_Accounts");
        });

        modelBuilder.Entity<Budget>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.StartDate).HasColumnType("date");
            entity.Property(e => e.EndDate).HasColumnType("date");
        });

        modelBuilder.Entity<BudgetAmount>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.AmountDate).HasColumnType("date");

            entity.HasOne(d => d.Account).WithMany()
               .HasForeignKey(d => d.AccountId)
               .OnDelete(DeleteBehavior.Cascade)
               .HasConstraintName("FK_BudgetAmount_Account");

            entity.HasOne(d => d.Budget).WithMany(b => b.Amounts)
               .HasForeignKey(d => d.BudgetId)
               .OnDelete(DeleteBehavior.ClientSetNull)
               .HasConstraintName("FK_BudgetAmount_Budget");
        });

        modelBuilder.Entity<Commodity>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Cusip).HasMaxLength(255);
            entity.Property(e => e.Mnemonic).HasMaxLength(255);
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.Updated).HasColumnType("datetime");
            entity.Property(e => e.Symbol).HasMaxLength(1);
        });

        modelBuilder.Entity<Price>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Date).HasColumnType("date");
            entity.Property(e => e.Value).HasColumnType("decimal(28, 9)");
            entity.HasOne(d => d.Commodity).WithMany()
                .HasForeignKey(d => d.CommodityId)
                .HasConstraintName("FK_Prices_Commodities");
        });

        modelBuilder.Entity<Setting>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Value).HasMaxLength(4096);
        });

        modelBuilder.Entity<Split>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Action).HasMaxLength(2048);
            entity.Property(e => e.Memo).HasMaxLength(2048);
            entity.Property(e => e.Quantity).HasColumnType("decimal(28, 9)");
            entity.Property(e => e.Updated).HasColumnType("datetime");
            entity.Property(e => e.Value).HasColumnType("decimal(28, 9)");

            entity.HasOne(d => d.Account).WithMany(p => p.Splits)
                .HasForeignKey(d => d.AccountId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Splits_Accounts");

            entity.HasOne(d => d.Transaction).WithMany(p => p.Splits)
                .HasForeignKey(d => d.TransactionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Splits_Transactions");
        });

        modelBuilder.Entity<Transaction>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).ValueGeneratedNever();

            entity.Property(e => e.Description).HasMaxLength(2048);
            entity.Property(e => e.PostDate).HasColumnType("date");
            entity.Property(e => e.Updated).HasColumnType("datetime");
        });
    }
}
