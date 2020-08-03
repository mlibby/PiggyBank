exports.AccountRepo = class AccountRepo {
  constructor(db) {
    this.db = db
  }

  validateResult(result, account) {
    if (result.changes > 0) {

      account.md5 = result.rows[0].md5
    }
    else {
      this.validateVersion(account.accountId, account.version)
    }
  }

  validateVersion(id, version) {
    const stmt = this.db.prepare(`
      SELECT
        "accountId",
        "version"
      FROM account
      WHERE accountId = ?`)

    const result = stmt.get(id)
    if (result && result.version !== version) {
      throw new Error("version mismatch")
    }
    else {
      throw new Error("id mismatch")
    }
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        "accountId",
        "currencyId",
        "name",
        "isPlaceholder",
        "parentId",
        "version"
      FROM account`)

    const results = stmt.all()
    return results
  }

  select(id) {
    const stmt = this.db.prepare(`
      SELECT
        "accountId",
        "currencyId",
        "name",
        "isPlaceholder",
        "parentId",
        "version"
      FROM account`)

    const result = stmt.get()
    return result
  }

  insert(account) {
    const stmt = this.db.prepare(`
      INSERT INTO account (
        "currencyId",
        "name",
        "isPlaceholder",
        "parentId",
        "version"
      )
      VALUES (?, ?, ?, ?, getVersion())
      `)

    const result = stmt.run(
      account.currencyId,
      account.name,
      account.isPlaceholder,
      account.parentId,
    )

    account = this.select(result.lastInsertRowid)
    return account
  }

  update(account) {
    const stmt = this.db.prepare(`
      UPDATE account 
      SET "currencyId" = ?,
        "name" = ?,
        "isPlaceholder" = ?,
        "parentId" = ?
      WHERE "accountId" = ? and "version" = ?`)

    const result = stmt.run(
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
