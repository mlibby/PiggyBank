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

        public async Task ImportCommodities()
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