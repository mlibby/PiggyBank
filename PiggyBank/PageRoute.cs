namespace PiggyBank;

public static class PageRoute
{
    public const string AccountIndex = "/account";
    public const string BudgetAdd = "/budget/add";

    public const string BudgetAmountAdd = "/budget/{BudgetId:guid}/account/add";
    public static string BudgetAmountAddFor(Guid budgetId) => $"/budget/{budgetId}/account/add";

    public const string BudgetAmountCalculate = "/budget/{BudgetId:guid}/amount/calculate";
    public static string BudgetAmountCalculateFor(Guid budgetId) => $"/budget/{budgetId}/amount/calculate";

    public const string BudgetAmountEdit = "/budget/{BudgetId:guid}/account/{AccountId:guid}/edit";
    public static string BudgetAmountEditFor(Guid budgetId, Guid accountId) => $"/budget/{budgetId}/account/{accountId}/edit";

    public const string BudgetAmountIndex = "/budget/{BudgetId:guid}/amount";
    public static string BudgetAmountIndexFor(Guid budgetId) => $"/budget/{budgetId}/amount";

    public const string BudgetEdit = "/budget/{BudgetId:guid}/edit";
    public static string BudgetEditFor(Guid budgetId) => $"/budget/{budgetId}/edit";

    public const string BudgetIndex = "/budget";
    public const string CommodityIndex = "/commodity";
    public const string ImportGnuCash = "/import/gnucash";
    public const string ImportOfx = "/import/ofx";
    public const string ReportBalances = "/report/balances";
    public const string ReportBudget = "/report/budget";
    public const string ReportIncomeExpense = "/report/income-expense";
    public const string TransactionIndex = "/transaction";
}
