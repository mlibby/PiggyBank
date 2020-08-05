exports.AccountRepo = class AccountRepo {
  constructor(db, validateFn) {
    this.db = db
    this.validateFn = validateFn
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
      account.version
    )

    this.validateFn(result, account, "account", "accountId")
    return account
  }

  delete(account) {
    const stmt = this.db.prepare(`
      DELETE FROM account
      WHERE "accountId" = ? AND "version" = ?`)

    const result = stmt.run(
      account.accountId,
      account.version
    )

    this.validateFn(result, account, "account", "accountId")
  }
}
