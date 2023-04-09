namespace PiggyBank.Models
{
    public interface IPiggyBankContext
    {
        Microsoft.EntityFrameworkCore.DbSet<Configuration> Configurations { get; set; }
    }
}
