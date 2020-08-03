exports.AccountRepo = class AccountRepo {
  constructor(db) {
    this.db = db
  }

  validateResult(result, account) {
    if (result.rowCount > 0) {
      account.md5 = result.rows[0].md5
    }
    else {
      this.validateVersion(account.accountId, account.version)
    }
  }

  validateVersion(id, version) {
    const stmt = this.db.prepare(`
      SELECT
        account_id "accountId",
        md5(account::text)
      FROM account
      WHERE account_id = $1`)

    const result = stmt.get(id)
    if (result.rowCount === 1 && result.rows[0].md5 !== md5) {
      throw new Error("md5 mismatch")
    }
    else {
      throw new Error("id mismatch")
    }
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        account_id "accountId",
        currency_id "currencyId",
        account_name "name",
        is_placeholder "isPlaceholder",
        parent_id "parentId",
        md5(account::text) "md5"
      FROM account`)

    const results = stmt.all()
    return results
  }

  insert(account) {
    const stmt = this.db.prepare(`
      INSERT INTO account (
        currency_id,
        account_name,
        is_placeholder,
        parent_id
      )
      VALUES ($1, $2, $3, $4)
      RETURNING *, md5(account::text)`)

    const result = stmt.get(
      account.currencyId,
      account.name,
      account.isPlaceholder,
      account.parentId,
    )
    account.accountId = result.rows[0].account_id
    account.md5 = result.rows[0].md5
    return account
  }

  update(account) {
    const stmt = this.db.prepare(`
      UPDATE account 
      SET currency_id = $1,
        account_name = $2,
        is_placeholder = $3,
        parent_id = $4
      WHERE account_id = $5 and md5(account::text) = $6
      RETURNING *, md5(account::text)`)

    const result = stmt.get(
      account.currencyId,
      account.name,
      account.isPlaceholder,
      account.parentId,
      account.accountId,
      account.md5
    )

    this.validateResult(result, account)
    return account
  }

  delete(account) {
    const stmt = this.db.prepare(`
      DELETE FROM account
      WHERE account_id = $1 AND md5(account::text) = $2
      RETURNING *, md5(account::text)`)

    const result = stmt.get(
      account.accountId,
      account.md5
    )

    this.validateResult(result, account)
  }
}
