using PiggyBank.Models;

namespace PiggyBank
{
    public class Command
    {
        private IPiggyBankContext Context { get; }
        public Command(IPiggyBankContext context)
        {
            Context = context;
        }

        public void Configure(string key, string value)
        {
            //var setting = Context.Configurations.

        }
    }
}
