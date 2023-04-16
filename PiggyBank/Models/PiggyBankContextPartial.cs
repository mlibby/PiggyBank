namespace PiggyBank.Models;

public partial class PiggyBankContext : DbContext, IPiggyBankContext
{
    private string _connectionString = "";

    public PiggyBankContext(string connectionString)
    {
        _connectionString = connectionString;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(_connectionString);
    }
}
