namespace PiggyBank.Import.GnuCash
{
    public class Account
    {
        public enum GnuCashAccountType
        {
            Asset,
            Bank,
            Cash,
            Credit,
            Equity,
            Expense,
            Income,
            Liability,
            Mutual,
            Payable,
            Receivable,
            Stock,
        }

        public GnuCashAccountType Type { get; set; }
        public string Code { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Notes { get; set; } = string.Empty;
        public string Symbol { get; set; } = string.Empty;
    }
}
