using PiggyBank.Data.Import.GnuCash.Models;

namespace PiggyBank.Data.Import.GnuCash;

public interface IGnuCashContext
{
    DbSet<GncAccount> Accounts { get; set; }

    DbSet<GncBillTerm> BillTerms { get; set; }

    DbSet<GncBook> Books { get; set; }

    DbSet<GncBudget> Budgets { get; set; }

    DbSet<GncBudgetAmount> BudgetAmounts { get; set; }

    DbSet<GncCommodity> Commodities { get; set; }

    DbSet<GncCustomer> Customers { get; set; }

    DbSet<GncEmployee> Employees { get; set; }

    DbSet<GncEntry> Entries { get; set; }

    DbSet<GncInvoice> Invoices { get; set; }

    DbSet<GncJob> Jobs { get; set; }

    DbSet<GncLot> Lots { get; set; }

    DbSet<GncOrder> Orders { get; set; }

    DbSet<GncPrice> Prices { get; set; }

    DbSet<GncRecurrence> Recurrences { get; set; }

    DbSet<GncScheduledTransaction> ScheduledTransactions { get; set; }

    DbSet<GncSlot> Slots { get; set; }

    DbSet<GncSplit> Splits { get; set; }

    DbSet<GncTransaction> Transactions { get; set; }

    DbSet<GncVendor> Vendors { get; set; }
}
