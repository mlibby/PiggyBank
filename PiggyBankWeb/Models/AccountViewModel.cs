using System.Collections.Generic;

namespace PiggyBankWeb.Models
{
    public class AccountViewModel
    {
        public string FullName { get; }
        public string Name { get; }

        public AccountViewModel(PiggyBank.Models.Account account)
        {
            Name = account.Name;
            FullName = GetFullName(account);
        }

        private string GetFullName(PiggyBank.Models.Account account)
        {
            var names = new List<string> { account.Name };
            while (account.Parent is object)
            {
                names.Add(account.Parent.Name);
                account = account.Parent;
            }

            names.Reverse();
            return string.Join(':', names);
        }
    }
}
