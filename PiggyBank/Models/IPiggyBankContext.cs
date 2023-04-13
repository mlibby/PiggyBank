namespace PiggyBank.Models;

public interface IPiggyBankContext
{
    DbSet<Account> Accounts { get; set; }
    DbSet<Configuration> Configurations { get; set; }

    int SaveChanges();
}
