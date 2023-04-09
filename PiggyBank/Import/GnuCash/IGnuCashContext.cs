using Microsoft.EntityFrameworkCore;

namespace PiggyBank.Import.GnuCash
{
    public interface IGnuCashContext
    {
        DbSet<Account> Accounts { get; set; }

        DbSet<BillTerm> BillTerms { get; set; }

        DbSet<Book> Books { get; set; }

        DbSet<Budget> Budgets { get; set; }

        DbSet<BudgetAmount> BudgetAmounts { get; set; }

        DbSet<Commodity> Commodities { get; set; }

        DbSet<Customer> Customers { get; set; }

        DbSet<Employee> Employees { get; set; }

        DbSet<Entry> Entries { get; set; }

        DbSet<Invoice> Invoices { get; set; }

        DbSet<Job> Jobs { get; set; }

        DbSet<Lot> Lots { get; set; }

        DbSet<Order> Orders { get; set; }

        DbSet<Price> Prices { get; set; }

        DbSet<Recurrence> Recurrences { get; set; }

        DbSet<ScheduledTransaction> ScheduledTransactions { get; set; }

        DbSet<Slot> Slots { get; set; }

        DbSet<Split> Splits { get; set; }

        DbSet<Transaction> Transactions { get; set; }

        DbSet<Vendor> Vendors { get; set; }
    }
}
