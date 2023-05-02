using PiggyBank.Data.Import.GnuCash;
using PiggyBank.Data.Import.GnuCash.Models;

namespace PiggyBank.Data.Services
{
    public class ImportService
    {
        private GnuCashContext _gnuCashContext;
        private PiggyBankContext _piggyBankContext;

        public ImportService(PiggyBankContext piggyBankContext, GnuCashContext gnuCashContext)
        {
            _gnuCashContext = gnuCashContext;
            _piggyBankContext = piggyBankContext;
        }

        public async Task<int> ImportAccountsAsync()
        {
            var accounts = new List<GncAccount>();
            var rootAccount = await _gnuCashContext.Accounts.SingleAsync(a => a.AccountType == "ROOT" && a.Name == "Root Account");
            var gnuCashAccounts = await GetGnuCashAccounts(rootAccount.Guid, accounts);
            foreach (var gncAccount in gnuCashAccounts)
            {
                if (gncAccount.ParentGuid == rootAccount.Guid)
                {
                    gncAccount.ParentGuid = null;
                }

                Account? account = await _piggyBankContext.Accounts.SingleOrDefaultAsync(a => a.Id == Guid.Parse(gncAccount.Guid));
                if (account is object && !account.IsLocked)
                {
                    UpdateAccount(gncAccount, account!);
                    await _piggyBankContext.SaveChangesAsync();
                    continue;
                }

                account = new Account();
                _piggyBankContext.Accounts.Add(account);
                UpdateAccount(gncAccount, account!);
                await _piggyBankContext.SaveChangesAsync();
            }

            return gnuCashAccounts.Count;
        }


        public async Task ImportCommoditiesAsync()
        {
            foreach (var gncCommodity in await _gnuCashContext.Commodities.ToListAsync())
            {
                if (gncCommodity.Namespace == "template") continue;

                var symbol = await _gnuCashContext.Slots
                    .SingleOrDefaultAsync(s => s.ObjGuid == gncCommodity.Guid && s.Name == "user_symbol");

                Guid guid = Guid.Parse(gncCommodity.Guid);
                Commodity? commodity = await _piggyBankContext
                    .Commodities.SingleOrDefaultAsync(c => c.Id == guid);

                if (commodity is object)
                {
                    UpdateCommodity(gncCommodity, commodity!, symbol);
                    await _piggyBankContext.SaveChangesAsync();
                    continue;
                }

                commodity = new Commodity();
                _piggyBankContext.Commodities.Add(commodity);
                UpdateCommodity(gncCommodity, commodity!, symbol);
                await _piggyBankContext.SaveChangesAsync();
            }
        }

        /// <summary>
        /// Returns a list of GnuCash accounts in order from parent to child.
        /// Useful for imports so that relationship to parent will be valid on insert.
        /// </summary>
        /// <param name="gnuCashContext"></param>
        /// <param name="parentGuid"></param>
        /// <param name="accounts"></param>
        /// <returns></returns>
        private async Task<List<GncAccount>> GetGnuCashAccounts(string parentGuid, List<GncAccount> accounts)
        {
            var childAccounts = await _gnuCashContext.Accounts.Where(a => a.ParentGuid == parentGuid).ToListAsync();
            accounts.AddRange(childAccounts);
            foreach (var childAccount in childAccounts)
            {
                await GetGnuCashAccounts(childAccount.Guid, accounts);
            }

            return accounts;
        }

        private void UpdateAccount(GncAccount gncAccount, Account account)
        {
            account.Id = Guid.Parse(gncAccount.Guid);
            account.Name = gncAccount.Name;
            account.ParentId = gncAccount.ParentGuid is object ? Guid.Parse(gncAccount.ParentGuid!) : null;
            account.Description = gncAccount.Description!;
            account.CommodityId = Guid.Parse(gncAccount.CommodityGuid!);
            account.Type = gncAccount.PiggyBankAccountType;
            account.IsPlaceholder = gncAccount.Placeholder > 0;
            account.IsHidden = gncAccount.Hidden > 0;
        }

        private void UpdateCommodity(GncCommodity gncCommodity, Commodity commodity, GncSlot? symbol)
        {
            commodity.Id = Guid.Parse(gncCommodity.Guid);
            commodity.Cusip = gncCommodity.Cusip;
            commodity.Mnemonic = gncCommodity.Mnemonic;
            commodity.Name = gncCommodity.Fullname;
            commodity.Precision = gncCommodity.Fraction.ToString().Length - 1;
            commodity.Symbol = symbol?.StringVal;
            commodity.Type = GncCommodity.TypeMap[gncCommodity.Namespace];
        }
    }
}