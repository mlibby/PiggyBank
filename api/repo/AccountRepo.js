class AccountRepo {
  constructor(queryFn) {
    this.queryFn = queryFn;
  }

  async selectAll() {
    const sql = `
    SELECT
      account_id "accountId",
      currency_id "currencyId",
      account_name "name",
      is_placeholder "isPlaceholder",
      parent_id "parentId"
    FROM account
    `;
    const results = await this.queryFn(sql);
    return results.rows;
  }

  async insert(account) {
    const sql = `INSERT INTO account (
      currency_id,
      account_name,
      is_placeholder,
      parent_id
    )
    VALUES ($1, $2, $3, $4)
    RETURNING *`;
    const result = await this.queryFn(sql, [
      account.currencyId,
      account.name,
      account.isPlaceholder,
      account.parentId
    ]);
    account.accountId = result.rows[0].account_id;
    return account;
  }
}

module.exports = AccountRepo;