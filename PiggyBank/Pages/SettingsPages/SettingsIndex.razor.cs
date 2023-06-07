namespace PiggyBank.Pages.SettingsPages;

public partial class SettingsIndex
{
    [Inject] private NotificationService SettingsService { get; set; } = default!;

    private bool _loading = true;
}
