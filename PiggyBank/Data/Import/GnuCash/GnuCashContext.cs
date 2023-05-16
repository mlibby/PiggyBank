using PiggyBank.Data.Import.GnuCash.Models;

namespace PiggyBank.Data.Import.GnuCash;

public partial class GnuCashContext : DbContext
{
    public GnuCashContext(DbContextOptions<GnuCashContext> options) : base(options) { }

    public virtual DbSet<GncAccount> Accounts { get; set; }

    public virtual DbSet<GncBillTerm> BillTerms { get; set; }

    public virtual DbSet<GncBook> Books { get; set; }

    public virtual DbSet<GncBudget> Budgets { get; set; }

    public virtual DbSet<GncBudgetAmount> BudgetAmounts { get; set; }

    public virtual DbSet<GncCommodity> Commodities { get; set; }

    public virtual DbSet<GncCustomer> Customers { get; set; }

    public virtual DbSet<GncEmployee> Employees { get; set; }

    public virtual DbSet<GncEntry> Entries { get; set; }

    public virtual DbSet<GncInvoice> Invoices { get; set; }

    public virtual DbSet<GncJob> Jobs { get; set; }

    public virtual DbSet<GncLot> Lots { get; set; }

    public virtual DbSet<GncOrder> Orders { get; set; }

    public virtual DbSet<GncPrice> Prices { get; set; }

    public virtual DbSet<GncRecurrence> Recurrences { get; set; }

    public virtual DbSet<GncScheduledTransaction> ScheduledTransactions { get; set; }

    public virtual DbSet<GncSlot> Slots { get; set; }

    public virtual DbSet<GncSplit> Splits { get; set; }

    public virtual DbSet<GncTransaction> Transactions { get; set; }

    public virtual DbSet<GncVendor> Vendors { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<GncAccount>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("accounts");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.AccountType)
                .HasColumnType("text(2048)")
                .HasColumnName("account_type");
            entity.Property(e => e.Code)
                .HasColumnType("text(2048)")
                .HasColumnName("code");
            entity.Property(e => e.CommodityGuid)
                .HasColumnType("text(32)")
                .HasColumnName("commodity_guid");
            entity.Property(e => e.CommodityScu).HasColumnName("commodity_scu");
            entity.Property(e => e.Description)
                .HasColumnType("text(2048)")
                .HasColumnName("description");
            entity.Property(e => e.Hidden).HasColumnName("hidden");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.NonStdScu).HasColumnName("non_std_scu");
            entity.Property(e => e.ParentGuid)
                .HasColumnType("text(32)")
                .HasColumnName("parent_guid");
            entity.Property(e => e.Placeholder).HasColumnName("placeholder");
        });

        modelBuilder.Entity<GncBillTerm>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("billterms");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Cutoff).HasColumnName("cutoff");
            entity.Property(e => e.Description)
                .HasColumnType("text(2048)")
                .HasColumnName("description");
            entity.Property(e => e.DiscountDenom)
                .HasColumnType("bigint")
                .HasColumnName("discount_denom");
            entity.Property(e => e.DiscountNum)
                .HasColumnType("bigint")
                .HasColumnName("discount_num");
            entity.Property(e => e.Discountdays).HasColumnName("discountdays");
            entity.Property(e => e.Duedays).HasColumnName("duedays");
            entity.Property(e => e.Invisible).HasColumnName("invisible");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.Parent)
                .HasColumnType("text(32)")
                .HasColumnName("parent");
            entity.Property(e => e.Refcount).HasColumnName("refcount");
            entity.Property(e => e.Type)
                .HasColumnType("text(2048)")
                .HasColumnName("type");
        });

        modelBuilder.Entity<GncBook>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("books");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.RootAccountGuid)
                .HasColumnType("text(32)")
                .HasColumnName("root_account_guid");
            entity.Property(e => e.RootTemplateGuid)
                .HasColumnType("text(32)")
                .HasColumnName("root_template_guid");
        });

        modelBuilder.Entity<GncBudget>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("budgets");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Description)
                .HasColumnType("text(2048)")
                .HasColumnName("description");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.NumPeriods).HasColumnName("num_periods");
        });

        modelBuilder.Entity<GncBudgetAmount>(entity =>
        {
            entity.ToTable("budget_amounts");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AccountGuid)
                .HasColumnType("text(32)")
                .HasColumnName("account_guid");
            entity.Property(e => e.AmountDenom)
                .HasColumnType("bigint")
                .HasColumnName("amount_denom");
            entity.Property(e => e.AmountNum)
                .HasColumnType("bigint")
                .HasColumnName("amount_num");
            entity.Property(e => e.BudgetGuid)
                .HasColumnType("text(32)")
                .HasColumnName("budget_guid");
            entity.Property(e => e.PeriodNum).HasColumnName("period_num");
        });

        modelBuilder.Entity<GncCommodity>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("commodities");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Cusip)
                .HasColumnType("text(2048)")
                .HasColumnName("cusip");
            entity.Property(e => e.Fraction).HasColumnName("fraction");
            entity.Property(e => e.Fullname)
                .HasColumnType("text(2048)")
                .HasColumnName("fullname");
            entity.Property(e => e.Mnemonic)
                .HasColumnType("text(2048)")
                .HasColumnName("mnemonic");
            entity.Property(e => e.Namespace)
                .HasColumnType("text(2048)")
                .HasColumnName("namespace");
            entity.Property(e => e.QuoteFlag).HasColumnName("quote_flag");
            entity.Property(e => e.QuoteSource)
                .HasColumnType("text(2048)")
                .HasColumnName("quote_source");
            entity.Property(e => e.QuoteTz)
                .HasColumnType("text(2048)")
                .HasColumnName("quote_tz");
        });

        modelBuilder.Entity<GncCustomer>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("customers");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.AddrAddr1)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr1");
            entity.Property(e => e.AddrAddr2)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr2");
            entity.Property(e => e.AddrAddr3)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr3");
            entity.Property(e => e.AddrAddr4)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr4");
            entity.Property(e => e.AddrEmail)
                .HasColumnType("text(256)")
                .HasColumnName("addr_email");
            entity.Property(e => e.AddrFax)
                .HasColumnType("text(128)")
                .HasColumnName("addr_fax");
            entity.Property(e => e.AddrName)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_name");
            entity.Property(e => e.AddrPhone)
                .HasColumnType("text(128)")
                .HasColumnName("addr_phone");
            entity.Property(e => e.CreditDenom)
                .HasColumnType("bigint")
                .HasColumnName("credit_denom");
            entity.Property(e => e.CreditNum)
                .HasColumnType("bigint")
                .HasColumnName("credit_num");
            entity.Property(e => e.Currency)
                .HasColumnType("text(32)")
                .HasColumnName("currency");
            entity.Property(e => e.DiscountDenom)
                .HasColumnType("bigint")
                .HasColumnName("discount_denom");
            entity.Property(e => e.DiscountNum)
                .HasColumnType("bigint")
                .HasColumnName("discount_num");
            entity.Property(e => e.Id)
                .HasColumnType("text(2048)")
                .HasColumnName("id");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.Notes)
                .HasColumnType("text(2048)")
                .HasColumnName("notes");
            entity.Property(e => e.ShipaddrAddr1)
                .HasColumnType("text(1024)")
                .HasColumnName("shipaddr_addr1");
            entity.Property(e => e.ShipaddrAddr2)
                .HasColumnType("text(1024)")
                .HasColumnName("shipaddr_addr2");
            entity.Property(e => e.ShipaddrAddr3)
                .HasColumnType("text(1024)")
                .HasColumnName("shipaddr_addr3");
            entity.Property(e => e.ShipaddrAddr4)
                .HasColumnType("text(1024)")
                .HasColumnName("shipaddr_addr4");
            entity.Property(e => e.ShipaddrEmail)
                .HasColumnType("text(256)")
                .HasColumnName("shipaddr_email");
            entity.Property(e => e.ShipaddrFax)
                .HasColumnType("text(128)")
                .HasColumnName("shipaddr_fax");
            entity.Property(e => e.ShipaddrName)
                .HasColumnType("text(1024)")
                .HasColumnName("shipaddr_name");
            entity.Property(e => e.ShipaddrPhone)
                .HasColumnType("text(128)")
                .HasColumnName("shipaddr_phone");
            entity.Property(e => e.TaxIncluded).HasColumnName("tax_included");
            entity.Property(e => e.TaxOverride).HasColumnName("tax_override");
            entity.Property(e => e.Taxtable)
                .HasColumnType("text(32)")
                .HasColumnName("taxtable");
            entity.Property(e => e.Terms)
                .HasColumnType("text(32)")
                .HasColumnName("terms");
        });

        modelBuilder.Entity<GncEmployee>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("employees");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Acl)
                .HasColumnType("text(2048)")
                .HasColumnName("acl");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.AddrAddr1)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr1");
            entity.Property(e => e.AddrAddr2)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr2");
            entity.Property(e => e.AddrAddr3)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr3");
            entity.Property(e => e.AddrAddr4)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr4");
            entity.Property(e => e.AddrEmail)
                .HasColumnType("text(256)")
                .HasColumnName("addr_email");
            entity.Property(e => e.AddrFax)
                .HasColumnType("text(128)")
                .HasColumnName("addr_fax");
            entity.Property(e => e.AddrName)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_name");
            entity.Property(e => e.AddrPhone)
                .HasColumnType("text(128)")
                .HasColumnName("addr_phone");
            entity.Property(e => e.CcardGuid)
                .HasColumnType("text(32)")
                .HasColumnName("ccard_guid");
            entity.Property(e => e.Currency)
                .HasColumnType("text(32)")
                .HasColumnName("currency");
            entity.Property(e => e.Id)
                .HasColumnType("text(2048)")
                .HasColumnName("id");
            entity.Property(e => e.Language)
                .HasColumnType("text(2048)")
                .HasColumnName("language");
            entity.Property(e => e.RateDenom)
                .HasColumnType("bigint")
                .HasColumnName("rate_denom");
            entity.Property(e => e.RateNum)
                .HasColumnType("bigint")
                .HasColumnName("rate_num");
            entity.Property(e => e.Username)
                .HasColumnType("text(2048)")
                .HasColumnName("username");
            entity.Property(e => e.WorkdayDenom)
                .HasColumnType("bigint")
                .HasColumnName("workday_denom");
            entity.Property(e => e.WorkdayNum)
                .HasColumnType("bigint")
                .HasColumnName("workday_num");
        });

        modelBuilder.Entity<GncEntry>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("entries");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Action)
                .HasColumnType("text(2048)")
                .HasColumnName("action");
            entity.Property(e => e.BAcct)
                .HasColumnType("text(32)")
                .HasColumnName("b_acct");
            entity.Property(e => e.BPaytype).HasColumnName("b_paytype");
            entity.Property(e => e.BPriceDenom)
                .HasColumnType("bigint")
                .HasColumnName("b_price_denom");
            entity.Property(e => e.BPriceNum)
                .HasColumnType("bigint")
                .HasColumnName("b_price_num");
            entity.Property(e => e.BTaxable).HasColumnName("b_taxable");
            entity.Property(e => e.BTaxincluded).HasColumnName("b_taxincluded");
            entity.Property(e => e.BTaxtable)
                .HasColumnType("text(32)")
                .HasColumnName("b_taxtable");
            entity.Property(e => e.Bill)
                .HasColumnType("text(32)")
                .HasColumnName("bill");
            entity.Property(e => e.Billable).HasColumnName("billable");
            entity.Property(e => e.BilltoGuid)
                .HasColumnType("text(32)")
                .HasColumnName("billto_guid");
            entity.Property(e => e.BilltoType).HasColumnName("billto_type");
            entity.Property(e => e.Date)
                .HasColumnType("text(19)")
                .HasColumnName("date");
            entity.Property(e => e.DateEntered)
                .HasColumnType("text(19)")
                .HasColumnName("date_entered");
            entity.Property(e => e.Description)
                .HasColumnType("text(2048)")
                .HasColumnName("description");
            entity.Property(e => e.IAcct)
                .HasColumnType("text(32)")
                .HasColumnName("i_acct");
            entity.Property(e => e.IDiscHow)
                .HasColumnType("text(2048)")
                .HasColumnName("i_disc_how");
            entity.Property(e => e.IDiscType)
                .HasColumnType("text(2048)")
                .HasColumnName("i_disc_type");
            entity.Property(e => e.IDiscountDenom)
                .HasColumnType("bigint")
                .HasColumnName("i_discount_denom");
            entity.Property(e => e.IDiscountNum)
                .HasColumnType("bigint")
                .HasColumnName("i_discount_num");
            entity.Property(e => e.IPriceDenom)
                .HasColumnType("bigint")
                .HasColumnName("i_price_denom");
            entity.Property(e => e.IPriceNum)
                .HasColumnType("bigint")
                .HasColumnName("i_price_num");
            entity.Property(e => e.ITaxable).HasColumnName("i_taxable");
            entity.Property(e => e.ITaxincluded).HasColumnName("i_taxincluded");
            entity.Property(e => e.ITaxtable)
                .HasColumnType("text(32)")
                .HasColumnName("i_taxtable");
            entity.Property(e => e.Invoice)
                .HasColumnType("text(32)")
                .HasColumnName("invoice");
            entity.Property(e => e.Notes)
                .HasColumnType("text(2048)")
                .HasColumnName("notes");
            entity.Property(e => e.OrderGuid)
                .HasColumnType("text(32)")
                .HasColumnName("order_guid");
            entity.Property(e => e.QuantityDenom)
                .HasColumnType("bigint")
                .HasColumnName("quantity_denom");
            entity.Property(e => e.QuantityNum)
                .HasColumnType("bigint")
                .HasColumnName("quantity_num");
        });

        modelBuilder.Entity<GncInvoice>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("invoices");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.BillingId)
                .HasColumnType("text(2048)")
                .HasColumnName("billing_id");
            entity.Property(e => e.BilltoGuid)
                .HasColumnType("text(32)")
                .HasColumnName("billto_guid");
            entity.Property(e => e.BilltoType).HasColumnName("billto_type");
            entity.Property(e => e.ChargeAmtDenom)
                .HasColumnType("bigint")
                .HasColumnName("charge_amt_denom");
            entity.Property(e => e.ChargeAmtNum)
                .HasColumnType("bigint")
                .HasColumnName("charge_amt_num");
            entity.Property(e => e.Currency)
                .HasColumnType("text(32)")
                .HasColumnName("currency");
            entity.Property(e => e.DateOpened)
                .HasColumnType("text(19)")
                .HasColumnName("date_opened");
            entity.Property(e => e.DatePosted)
                .HasColumnType("text(19)")
                .HasColumnName("date_posted");
            entity.Property(e => e.Id)
                .HasColumnType("text(2048)")
                .HasColumnName("id");
            entity.Property(e => e.Notes)
                .HasColumnType("text(2048)")
                .HasColumnName("notes");
            entity.Property(e => e.OwnerGuid)
                .HasColumnType("text(32)")
                .HasColumnName("owner_guid");
            entity.Property(e => e.OwnerType).HasColumnName("owner_type");
            entity.Property(e => e.PostAcc)
                .HasColumnType("text(32)")
                .HasColumnName("post_acc");
            entity.Property(e => e.PostLot)
                .HasColumnType("text(32)")
                .HasColumnName("post_lot");
            entity.Property(e => e.PostTxn)
                .HasColumnType("text(32)")
                .HasColumnName("post_txn");
            entity.Property(e => e.Terms)
                .HasColumnType("text(32)")
                .HasColumnName("terms");
        });

        modelBuilder.Entity<GncJob>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("jobs");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.Id)
                .HasColumnType("text(2048)")
                .HasColumnName("id");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.OwnerGuid)
                .HasColumnType("text(32)")
                .HasColumnName("owner_guid");
            entity.Property(e => e.OwnerType).HasColumnName("owner_type");
            entity.Property(e => e.Reference)
                .HasColumnType("text(2048)")
                .HasColumnName("reference");
        });

        modelBuilder.Entity<GncLot>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("lots");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.AccountGuid)
                .HasColumnType("text(32)")
                .HasColumnName("account_guid");
            entity.Property(e => e.IsClosed).HasColumnName("is_closed");
        });

        modelBuilder.Entity<GncOrder>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("orders");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.DateClosed)
                .HasColumnType("text(19)")
                .HasColumnName("date_closed");
            entity.Property(e => e.DateOpened)
                .HasColumnType("text(19)")
                .HasColumnName("date_opened");
            entity.Property(e => e.Id)
                .HasColumnType("text(2048)")
                .HasColumnName("id");
            entity.Property(e => e.Notes)
                .HasColumnType("text(2048)")
                .HasColumnName("notes");
            entity.Property(e => e.OwnerGuid)
                .HasColumnType("text(32)")
                .HasColumnName("owner_guid");
            entity.Property(e => e.OwnerType).HasColumnName("owner_type");
            entity.Property(e => e.Reference)
                .HasColumnType("text(2048)")
                .HasColumnName("reference");
        });

        modelBuilder.Entity<GncPrice>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("prices");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.CommodityGuid)
                .HasColumnType("text(32)")
                .HasColumnName("commodity_guid");
            entity.Property(e => e.CurrencyGuid)
                .HasColumnType("text(32)")
                .HasColumnName("currency_guid");
            entity.Property(e => e.Date)
                .HasColumnType("text(19)")
                .HasColumnName("date");
            entity.Property(e => e.Source)
                .HasColumnType("text(2048)")
                .HasColumnName("source");
            entity.Property(e => e.Type)
                .HasColumnType("text(2048)")
                .HasColumnName("type");
            entity.Property(e => e.ValueDenomination)
                .HasColumnType("bigint")
                .HasColumnName("value_denom");
            entity.Property(e => e.ValueNumber)
                .HasColumnType("bigint")
                .HasColumnName("value_num");
        });

        modelBuilder.Entity<GncRecurrence>(entity =>
        {
            entity.ToTable("recurrences");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ObjGuid)
                .HasColumnType("text(32)")
                .HasColumnName("obj_guid");
            entity.Property(e => e.RecurrenceMult).HasColumnName("recurrence_mult");
            entity.Property(e => e.RecurrencePeriodStart)
                .HasColumnType("text(8)")
                .HasColumnName("recurrence_period_start");
            entity.Property(e => e.RecurrencePeriodType)
                .HasColumnType("text(2048)")
                .HasColumnName("recurrence_period_type");
            entity.Property(e => e.RecurrenceWeekendAdjust)
                .HasColumnType("text(2048)")
                .HasColumnName("recurrence_weekend_adjust");
        });

        modelBuilder.Entity<GncScheduledTransaction>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("schedxactions");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.AdvCreation).HasColumnName("adv_creation");
            entity.Property(e => e.AdvNotify).HasColumnName("adv_notify");
            entity.Property(e => e.AutoCreate).HasColumnName("auto_create");
            entity.Property(e => e.AutoNotify).HasColumnName("auto_notify");
            entity.Property(e => e.Enabled).HasColumnName("enabled");
            entity.Property(e => e.EndDate)
                .HasColumnType("text(8)")
                .HasColumnName("end_date");
            entity.Property(e => e.InstanceCount).HasColumnName("instance_count");
            entity.Property(e => e.LastOccur)
                .HasColumnType("text(8)")
                .HasColumnName("last_occur");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.NumOccur).HasColumnName("num_occur");
            entity.Property(e => e.RemOccur).HasColumnName("rem_occur");
            entity.Property(e => e.StartDate)
                .HasColumnType("text(8)")
                .HasColumnName("start_date");
            entity.Property(e => e.TemplateActGuid)
                .HasColumnType("text(32)")
                .HasColumnName("template_act_guid");
        });

        modelBuilder.Entity<GncSlot>(entity =>
        {
            entity.ToTable("slots");

            entity.HasIndex(e => e.ObjGuid, "slots_guid_index");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DoubleVal)
                .HasColumnType("float8")
                .HasColumnName("double_val");
            entity.Property(e => e.GdateVal)
                .HasColumnType("text(8)")
                .HasColumnName("gdate_val");
            entity.Property(e => e.GuidVal)
                .HasColumnType("text(32)")
                .HasColumnName("guid_val");
            entity.Property(e => e.Int64Val)
                .HasColumnType("bigint")
                .HasColumnName("int64_val");
            entity.Property(e => e.Name)
                .HasColumnType("text(4096)")
                .HasColumnName("name");
            entity.Property(e => e.NumericValDenom)
                .HasColumnType("bigint")
                .HasColumnName("numeric_val_denom");
            entity.Property(e => e.NumericValNum)
                .HasColumnType("bigint")
                .HasColumnName("numeric_val_num");
            entity.Property(e => e.ObjGuid)
                .HasColumnType("text(32)")
                .HasColumnName("obj_guid");
            entity.Property(e => e.SlotType).HasColumnName("slot_type");
            entity.Property(e => e.StringVal)
                .HasColumnType("text(4096)")
                .HasColumnName("string_val");
            entity.Property(e => e.TimespecVal)
                .HasColumnType("text(19)")
                .HasColumnName("timespec_val");
        });

        modelBuilder.Entity<GncSplit>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("splits");

            entity.HasIndex(e => e.AccountGuid, "splits_account_guid_index");

            entity.HasIndex(e => e.TransactionGuid, "splits_tx_guid_index");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.AccountGuid)
                .HasColumnType("text(32)")
                .HasColumnName("account_guid");
            entity.Property(e => e.Action)
                .HasColumnType("text(2048)")
                .HasColumnName("action");
            entity.Property(e => e.LotGuid)
                .HasColumnType("text(32)")
                .HasColumnName("lot_guid");
            entity.Property(e => e.Memo)
                .HasColumnType("text(2048)")
                .HasColumnName("memo");
            entity.Property(e => e.QuantityDenomination)
                .HasColumnType("bigint")
                .HasColumnName("quantity_denom");
            entity.Property(e => e.QuantityNumber)
                .HasColumnType("bigint")
                .HasColumnName("quantity_num");
            entity.Property(e => e.ReconcileDate)
                .HasColumnType("text(19)")
                .HasColumnName("reconcile_date");
            entity.Property(e => e.ReconcileState)
                .HasColumnType("text(1)")
                .HasColumnName("reconcile_state");
            entity.Property(e => e.TransactionGuid)
                .HasColumnType("text(32)")
                .HasColumnName("tx_guid");
            entity.Property(e => e.ValueDenomination)
                .HasColumnType("bigint")
                .HasColumnName("value_denom");
            entity.Property(e => e.ValueNumber)
                .HasColumnType("bigint")
                .HasColumnName("value_num");

            entity.HasOne(d => d.Transaction).WithMany(p => p.Splits)
                .HasForeignKey(d => d.TransactionGuid);
        });

        modelBuilder.Entity<GncTransaction>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("transactions");

            entity.HasIndex(e => e.PostDate, "tx_post_date_index");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.CurrencyGuid)
                .HasColumnType("text(32)")
                .HasColumnName("currency_guid");
            entity.Property(e => e.Description)
                .HasColumnType("text(2048)")
                .HasColumnName("description");
            entity.Property(e => e.EnterDate)
                .HasColumnType("text(19)")
                .HasColumnName("enter_date");
            entity.Property(e => e.Number)
                .HasColumnType("text(2048)")
                .HasColumnName("num");
            entity.Property(e => e.PostDate)
                .HasColumnType("text(19)")
                .HasColumnName("post_date");
        });

        modelBuilder.Entity<GncVendor>(entity =>
        {
            entity.HasKey(e => e.Guid);

            entity.ToTable("vendors");

            entity.Property(e => e.Guid)
                .HasColumnType("text(32)")
                .HasColumnName("guid");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.AddrAddr1)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr1");
            entity.Property(e => e.AddrAddr2)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr2");
            entity.Property(e => e.AddrAddr3)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr3");
            entity.Property(e => e.AddrAddr4)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_addr4");
            entity.Property(e => e.AddrEmail)
                .HasColumnType("text(256)")
                .HasColumnName("addr_email");
            entity.Property(e => e.AddrFax)
                .HasColumnType("text(128)")
                .HasColumnName("addr_fax");
            entity.Property(e => e.AddrName)
                .HasColumnType("text(1024)")
                .HasColumnName("addr_name");
            entity.Property(e => e.AddrPhone)
                .HasColumnType("text(128)")
                .HasColumnName("addr_phone");
            entity.Property(e => e.Currency)
                .HasColumnType("text(32)")
                .HasColumnName("currency");
            entity.Property(e => e.Id)
                .HasColumnType("text(2048)")
                .HasColumnName("id");
            entity.Property(e => e.Name)
                .HasColumnType("text(2048)")
                .HasColumnName("name");
            entity.Property(e => e.Notes)
                .HasColumnType("text(2048)")
                .HasColumnName("notes");
            entity.Property(e => e.TaxInc)
                .HasColumnType("text(2048)")
                .HasColumnName("tax_inc");
            entity.Property(e => e.TaxOverride).HasColumnName("tax_override");
            entity.Property(e => e.TaxTable)
                .HasColumnType("text(32)")
                .HasColumnName("tax_table");
            entity.Property(e => e.Terms)
                .HasColumnType("text(32)")
                .HasColumnName("terms");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}