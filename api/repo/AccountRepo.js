class AccountRepo {
  constructor(queryFn) {
    this.queryFn = queryFn;
  }

  async all() {
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
}

module.exports = AccountRepo;