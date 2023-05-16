namespace PiggyBank.Models;

public class ValidationWarning
{
    public object Entity { get; }
    public string Message { get; }

    public ValidationWarning(object invalidEntity, string message)
    {
        Entity = invalidEntity;
        Message = message;
    }
}
