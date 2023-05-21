namespace PiggyBank.Pages.Transaction;

public partial class ManageTransactions
{
    private bool _importing;
    private int _recordCount = 0;
    private int _recordsProcessed = 0;
    private IEnumerable<Data.Models.Transaction>? _transactions;
    protected override async Task OnInitializedAsync() => _transactions = await TransactionService.GetTransactionsAsync();

    async Task ImportClicked()
    {
        _importing = true;
        var count = new Progress<int>(value => _recordCount = value);
        var processed = new Progress<int>(value => _recordsProcessed = value);
        await ImportService.ImportTransactions(processed, count, CancellationToken.None);
        _transactions = await TransactionService.GetTransactionsAsync();
        _importing = false;

        // TODO: do we need this? Does the UI not refresh?
        // Either way we should only call this once during
        // this method so we don't redraw the UI an extra time.
        StateHasChanged();
    }
}
