namespace PiggyBank.Data.Services;

public record TransactionService(PiggyBankContext Context)
{
    public async Task<IEnumerable<Transaction>> GetTransactionsAsync() =>
        await Context.Transactions.ToListAsync();
}
