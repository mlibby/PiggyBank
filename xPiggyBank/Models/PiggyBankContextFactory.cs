using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace PiggyBank.Models
{
    public class PiggyBankContextFactory : IDesignTimeDbContextFactory<PiggyBankContext>
    {
        public PiggyBankContext CreateDbContext(string[] args)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(System.IO.Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();
            var connectionString = configuration.GetConnectionString("PiggyBankContext")!;

            var optionsBuilder = new DbContextOptionsBuilder<PiggyBankContext>();
            //optionsBuilder.UseSqlServer(connectionString);
            optionsBuilder.UseSqlite(connectionString);
            return new PiggyBankContext(optionsBuilder.Options);
        }
    }
}
