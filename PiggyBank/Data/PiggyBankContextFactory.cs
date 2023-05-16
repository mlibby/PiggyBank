using Microsoft.EntityFrameworkCore.Design;

namespace PiggyBank.Data;

public class PiggyBankContextFactory : IDesignTimeDbContextFactory<PiggyBankContext>
{
    public PiggyBankContext CreateDbContext(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        var piggyBankConnection = builder.Configuration.GetConnectionString("PiggyBankConnection") ?? throw new InvalidOperationException("Connection string 'PiggyBankConnection' not found.");

        var optionsBuilder = new DbContextOptionsBuilder<PiggyBankContext>();
        optionsBuilder.UseSqlite(piggyBankConnection);

        return new PiggyBankContext(optionsBuilder.Options);
    }
}