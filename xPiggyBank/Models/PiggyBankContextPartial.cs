using Microsoft.Extensions.Configuration;

namespace PiggyBank.Models
{
    public partial class PiggyBankContext
    {
        private string _connectionString = "";

        //public PiggyBankContext(string connectionString)
        //{
        //    _connectionString = connectionString;
        //}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(System.IO.Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();
            var connectionString = configuration.GetConnectionString("PiggyBankContext")!;

            optionsBuilder.UseSqlite(connectionString);
        }

    }
}
