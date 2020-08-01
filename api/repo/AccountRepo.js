exports.AccountRepo = class AccountRepo {
  constructor(queryFn) {
    this.queryFn = queryFn
  }

  validateResult(result, account) {
    if (result.rowCount > 0) {
      account.md5 = result.rows[0].md5
    }
    else {
     this.validateMd5(account.accountId, account.md5)
    }
  }

   validateMd5(id, md5) {
    const sql = `
      SELECT
        account_id "accountId",
        md5(account::text)
      FROM account
      WHERE account_id = $1`

    const result = await this.queryFn(sql, [id])
    if (result.rowCount === 1 && result.rows[0].md5 !== md5) {
      throw new Error("md5 mismatch")
    }
    else {
      throw new Error("id mismatch")
    }
  }

  async selectAll() {
    const sql = `
      SELECT
        account_id "accountId",
        currency_id "currencyId",
        account_name "name",
        is_placeholder "isPlaceholder",
        parent_id "parentId",
        md5(account::text) "md5"
      FROM account`

    const results = await this.queryFn(sql)
    return results.rows
  }

  async insert(account) {
    const sql = `
      INSERT INTO account (
        currency_id,
        account_name,
        is_placeholder,
        parent_id
      )
      VALUES ($1, $2, $3, $4)
      RETURNING *, md5(account::text)`

    const result = await this.queryFn(sql, [
      account.currencyId,
      account.name,
      account.isPlaceholder,
      account.parentId,
    ])
    account.accountId = result.rows[0].account_id
    account.md5 = result.rows[0].md5
    return account
  }

  async update(account) {
    const sql = `
      UPDATE account 
      SET currency_id = $1,
        account_name = $2,
        is_placeholder = $3,
        parent_id = $4
      WHERE account_id = $5 and md5(account::text) = $6
      RETURNING *, md5(account::text)`

    const result = await this.queryFn(sql, [
      account.currencyId,
      account.name,
      account.isPlaceholder,
      account.parentId,
      account.accountId,
      account.md5
    ])

    await this.validateResult(result, account)
    return account
  }

  async delete(account) {
    const sql = `
      DELETE FROM account
      WHERE account_id = $1 AND md5(account::text) = $2
      RETURNING *, md5(account::text)`

    const result = await this.queryFn(sql, [
      account.accountId,
      account.md5
    ])

    await this.validateResult(result, account)
  }
}
