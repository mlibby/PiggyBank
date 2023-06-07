namespace PiggyBank.Pages.CommodityPages;

public partial class ManageCommodities
{
    [Inject] private ImportService ImportService { get; set; } = default!;

    private bool _importing;
    private int _recordCount = 0;
    private int _recordsProcessed = 0;
    private IEnumerable<Commodity>? _commodities;

    protected override async Task OnInitializedAsync() => _commodities = await PiggyBankService.GetCommoditiesAsync();

    protected async Task Import()
    {
        _importing = true;
        var count = new Progress<int>(value => _recordCount = value);
        var processed = new Progress<int>(value => _recordsProcessed = value);
        await ImportService.ImportCommodities(processed, count, CancellationToken.None);
        _commodities = await PiggyBankService.GetCommoditiesAsync();
        _importing = false;

        // TODO: do we need this? Does the UI not refresh?
        // Either way we should only call this once during
        // this method so we don't redraw the UI an extra time.
        StateHasChanged();
    }
}
