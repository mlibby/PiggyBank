namespace PiggyBank.Data.Models;

public interface IChildish
{
    ICollection<IChildish> Children { get; set; }
}
