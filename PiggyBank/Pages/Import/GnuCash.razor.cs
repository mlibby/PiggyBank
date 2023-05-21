namespace PiggyBank.Pages.Import;

public partial class GnuCash
{
    private CancellationToken _importCancellationToken;
    private CancellationTokenSource? _importCancellationTokenSource;
    private bool _complete;
    private bool _importing;
    private int _commodityCount;
    private int _commodityProcessed;
    private Task? _commodityImportTask;
    private int _accountCount;
    private int _accountProcessed;
    private Task? _accountImportTask;
    private int _transactionCount;
    private int _transactionProcessed;
    private Task? _transactionImportTask;
    private float AccountProgress => _accountCount == 0 ? 0 : (float)_accountProcessed / _accountCount;
    private float CommodityProgress => _commodityCount == 0 ? 0 : (float)_commodityProcessed / _commodityCount;
    private float TransactionProgress => _transactionCount == 0 ? 0 : (float)_transactionProcessed / _transactionCount;

    protected async Task Import()
    {
        if (_importing)
        {
            return;
        }

        _importing = true;
        _complete = false;
        _commodityCount = 0;
        _commodityProcessed = 0;
        _accountCount = 0;
        _accountProcessed = 0;
        _transactionCount = 0;
        _transactionProcessed = 0;
        _importCancellationTokenSource = new CancellationTokenSource();
        _importCancellationToken = _importCancellationTokenSource.Token;

        var count = new Progress<int>(value => _commodityCount = value);
        var processed = new Progress<int>(value => _commodityProcessed = value);

        _commodityImportTask = ImportService.ImportCommodities(processed, count, _importCancellationToken);
        await _commodityImportTask;

        count = new Progress<int>(value => _accountCount = value);
        processed = new Progress<int>(value => _accountProcessed = value);

        _accountImportTask = ImportService.ImportAccounts(processed, count, _importCancellationToken);
        await _accountImportTask;

        count = new Progress<int>(value => _transactionCount = value);
        processed = new Progress<int>(value => _transactionProcessed = value);

        _transactionImportTask = ImportService.ImportTransactions(processed, count, _importCancellationToken);
        await _transactionImportTask;

        _importing = false;
        _complete = true;

        // TODO: do we need this? Does the UI not refresh?
        // Either way we should only call this once during
        // this method so we don't redraw the UI several
        // extra times.
        StateHasChanged();
    }

    public void Dispose()
    {
        if (_importCancellationTokenSource is null || !_importing)
        {
            return;
        }

        logger.LogInformation("Cancelling GnuCash imports");
        _importCancellationTokenSource.Cancel();
        MessageService.NotifyWarning("GnuCash imports cancelled");
    }
}
