//
// Inspired by https://github.com/radzenhq/radzen-blazor/blob/master/Radzen.Blazor/NotificationService.cs
//

namespace PiggyBank.Data.Services;

public class NotificationService
{
    public ObservableCollection<NotificationMessage> Messages { get; private set; } = new ObservableCollection<NotificationMessage>();

    public void NotifyError(string message) => Notify(NotificationSeverity.Error, message);
    public void NotifyInfo(string message) => Notify(NotificationSeverity.Info, message);
    public void NotifySuccess(string message) => Notify(NotificationSeverity.Success, message);
    public void NotifyWarning(string message) => Notify(NotificationSeverity.Warning, message);

    public void Notify(NotificationSeverity severity, string message)
    {
        var notificationMessage = new NotificationMessage
        {
            Message = message,
            Severity = severity
        };
        Messages.Add(notificationMessage);
    }
}

public enum NotificationSeverity
{
    Error,
    Info,
    Success,
    Warning
}

public class NotificationMessage
{
    public NotificationSeverity Severity { get; set; } = NotificationSeverity.Info;

    public string Message { get; set; } = "";
}
