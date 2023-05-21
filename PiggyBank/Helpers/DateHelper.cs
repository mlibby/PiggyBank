namespace PiggyBank.Helpers;

public class DateHelper
{
    public enum PeriodType
    {
        Monthly,
        Annual,
    }

    public static List<DateOnly> CalculatePeriods(DateOnly startDate, DateOnly endDate, PeriodType periodType = PeriodType.Monthly)
    {
        var periods = new List<DateOnly>();
        var monthsToAdd = periodType == PeriodType.Monthly ? 1 : 12;
        for (var thisDate = startDate; thisDate <= endDate; thisDate = thisDate.AddMonths(monthsToAdd))
        {
            periods.Add(thisDate);
        }

        return periods;
    }
}
