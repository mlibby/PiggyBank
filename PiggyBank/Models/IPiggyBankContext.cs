namespace PiggyBank.Models;

public interface IPiggyBankContext
{
    DbSet<Account> Accounts { get; set; }
    DbSet<Commodity> Commodities { get; set; }
    DbSet<Configuration> Configurations { get; set; }
    DbSet<ExternalId> ExternalIds { get; set; }

    int SaveChanges();
}
