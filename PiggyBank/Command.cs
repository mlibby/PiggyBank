namespace PiggyBank
{
    public class Command
    {
        public IPiggyBankContext Context { get; }

        public Command(IPiggyBankContext context)
        {
            Context = context;
        }

        public void Configure(string key, string value)
        {
            var config = Context.Configurations.SingleOrDefault(x => x.Key == key);
            if (config is object)
            {
                config.Value = value;
            }
            else
            {
                config = new Configuration
                {
                    Key = key,
                    Value = value
                };
                Context.Configurations.Add(config);
            }

            Context.SaveChanges();
        }

        public void ImportGnuCashAccounts(IGnuCashContext gnuCashContext)
        {
            foreach (var account in gnuCashContext.Accounts)
            {
                Console.WriteLine(account.Name);
            }
        }
    }
}
