namespace PiggyBank.Models
{
    public abstract class ModelBase
    {
        public virtual Guid Id { get; set; }

        public ModelBase()
        {
            Id = Guid.NewGuid();
        }
    }
}
