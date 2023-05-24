namespace PiggyBank.Helpers;

public static class DateHelper
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

    public static List<DateRange> CalculateDateRanges(DateOnly startDate, DateOnly endDate)
    {
        var periods = new List<DateRange>();
        for (var thisDate = startDate; thisDate <= endDate; thisDate = thisDate.AddMonths(1))
        {
            periods.Add(new DateRange(thisDate, thisDate.AddMonths(1).AddDays(-1)));
        }

        return periods;
    }
}
