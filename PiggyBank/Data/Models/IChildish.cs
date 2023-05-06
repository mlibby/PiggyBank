namespace PiggyBank.Data.Models;

public interface IChildish<T> where T : ModelBase
{
    ICollection<T> Children { get; set; }
}
