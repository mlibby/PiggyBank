namespace PiggyBank.Pages.BudgetPages;

public partial class BudgetAmountIndex
{
    [Inject] private BudgetService BudgetService { get; set; } = default!;

    [Parameter] public Guid BudgetId { get; set; }

    private bool _loading = true;
    private bool _found = true;
    private string _notFoundMessage = "not found";
    private Data.Models.Budget? _budget = null;
    private TreeTableModel? _model = null;

    protected override async Task OnParametersSetAsync()
    {
        _loading = true;
        _budget = await BudgetService.GetBudgetAndAmountsAsync(BudgetId);
        if (_budget is null)
        {
            _notFoundMessage = $"Budget with ID '{BudgetId}' not found";
            _found = false;
            return;
        }

        var periods = _budget.Amounts.Select(a => a.AmountDate).Distinct().Order();
        var columns = periods.Select(p => p.ToString()).ToList();
        _model = new("Budget Amounts", "Account", columns);
        var amounts = BuildAmountsDictionary(_budget);
        var orderedAccounts = _budget.Amounts.Select(a => a.Account).Distinct().OrderBy(a => a.FullName);
        foreach (var account in orderedAccounts)
        {
            List<string> values = new();
            foreach (var period in periods)
            {
                if (amounts.TryGetValue(account.Id, out var accountAmount) && accountAmount.TryGetValue(period, out var amount))
                {
                    values.Add(amount);
                }
                else
                {
                    values.Add("-");
                }
            }

            var node = new TreeTableNodeModel(account.FullName, values);
            _model.Nodes.Add(node);
        }

        _loading = false;
    }

    private static Dictionary<Guid, Dictionary<DateOnly, string>> BuildAmountsDictionary(Budget budget)
    {
        Dictionary<Guid, Dictionary<DateOnly, string>> dict = new();
        foreach (var amount in budget.Amounts)
        {
            if (!dict.ContainsKey(amount.AccountId))
            {
                dict[amount.AccountId] = new Dictionary<DateOnly, string>();
            }

            dict[amount.AccountId][amount.AmountDate] = amount.Account.Commodity.DisplayAmount(amount.Value);
        }

        return dict;
    }
}