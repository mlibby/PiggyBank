exports.AccountRepo = class AccountRepo {
  constructor(db, validateFn) {
    this.db = db
    this.validateFn = validateFn
  }

  // validateResult(result, account) {
  //   if (result.changes > 0) {
  //     const account2 = this.select(account.accountId)
  //     if (account2) {
  //       account.version = account2.version
  //     }
  //   }
  //   else {
  //     this.validateVersion(account.accountId, account.version)
  //   }
  // }

  // validateVersion(id, version) {
  //   const stmt = this.db.prepare(`
  //     SELECT
  //       "accountId",
  //       "version"
  //     FROM account
  //     WHERE accountId = ?`)

  //   const result = stmt.get(id)
  //   if (result && result.version !== version) {
  //     throw new Error("version mismatch")
  //   }
  //   else {
  //     throw new Error("id mismatch")
  //   }
  // }

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

    this.validateFn(account, "account", "accountId")
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

    this.validateFn(account, "account", "accountId")
  }
}
