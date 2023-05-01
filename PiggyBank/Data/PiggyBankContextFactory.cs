using Microsoft.EntityFrameworkCore.Design;

namespace PiggyBank.Data;

public class PiggyBankContextFactory : IDesignTimeDbContextFactory<PiggyBankContext>
{
    public PiggyBankContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<PiggyBankContext>();
        optionsBuilder.UseSqlite("Data Source=blog.db");

        return new PiggyBankContext(optionsBuilder.Options);
    }
}