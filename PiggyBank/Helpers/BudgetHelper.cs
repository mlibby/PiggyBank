namespace PiggyBank.Helpers;

public static class BudgetHelper
{
    public static void CalculateBudgetAmounts(Budget budget, BudgetAmount.Configuration config, ICollection<Account> accounts)
    {
        var amountBalances = new Balances(accounts, config.StartDate, config.EndDate);
        var periodCount = DateHelper.CalculatePeriods(config.StartDate, config.EndDate).Count;
        var budgetPeriods = DateHelper.CalculatePeriods(budget.StartDate, budget.EndDate);
        var amountType =
            config.DefaultPeriod == DateHelper.PeriodType.Monthly ?
            AmountType.Monthly :
            AmountType.Annual;

        foreach (var account in accounts.Where(a => !config.AccountTypes.Contains(a.AccountType)))
        {
            if (account.IsHidden || account.IsPlaceholder)
            {
                continue;
            }

            foreach (var period in budgetPeriods)
            {
                budget.Amounts.Add(new BudgetAmount
                {
                    Account = account,
                    AmountDate = period,
                    AmountType = amountType,
                    Value = decimal.Round(amountBalances[account.Id] / periodCount * (int)amountType, config.RoundTo),
                });
            }
        }
    }
}