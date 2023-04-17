namespace PiggyBank.Models
{
    public partial class ExternalId
    {
        public static void UpdateExternalId(IPiggyBankContext context, string externalId, int localId, ExternalId.IdType idType, ExternalId.SourceType sourceType)
        {
            var externalIdModel = new Models.ExternalId()
            {
                ExternalIdString = externalId,
                LocalId = localId,
                Source = sourceType,
                Type = idType,
            };
            context.ExternalIds.Add(externalIdModel);
            context.SaveChanges();
        }

        public static ExternalId? GetAccountId(IPiggyBankContext context, string externalId, ExternalId.SourceType sourceType)
        {
            return context.ExternalIds.SingleOrDefault(e =>
                e.Source == sourceType &&
                e.Type == ExternalId.IdType.Account &&
                e.ExternalIdString == externalId);
        }

        public static ExternalId? GetCommodityId(IPiggyBankContext context, string externalId, ExternalId.SourceType sourceType)
        {
            return context.ExternalIds.SingleOrDefault(e =>
                e.Source == sourceType &&
                e.Type == ExternalId.IdType.Commodity &&
                e.ExternalIdString == externalId);
        }
    }
}
