"use strict"

exports.AccountRepo = class AccountRepo {
  constructor(db, validateFn) {
    this.db = db
    this.validateFn = validateFn
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        "id",
        "parentId",
        "commodityId",
        "name",
        "isPlaceholder",
        "type",
        "typeData",
        "version"
      FROM account`)

    const results = stmt.all()
    return results
  }

  select(id) {
    const stmt = this.db.prepare(`
      SELECT
        "id",
        "parentId",
        "commodityId",
        "name",
        "isPlaceholder",
        "type",
        "typeData",
        "version"
      FROM account`)

    const result = stmt.get()
    return result
  }

  insert(account) {
    const stmt = this.db.prepare(`
      INSERT INTO account (
        "parentId",
        "commodityId",
        "name",
        "isPlaceholder",
        "type",
        "typeData",
        "version"
      )
      VALUES (?, ?, ?, ?, ?, ?, getVersion())
      `)

    const result = stmt.run(
      account.parentId,
      account.commodityId,
      account.name,
      account.isPlaceholder ? 1 : 0,
      account.type,
      JSON.stringify(account.typeData)
    )

    account = this.select(result.lastInsertRowid)
    return account
  }

  update(account) {
    const stmt = this.db.prepare(`
      UPDATE account 
      SET 
        "parentId" = ?,
        "commodityId" = ?,
        "name" = ?,
        "isPlaceholder" = ?,
        "type" = ?,
        "typeData" = ?
      WHERE "id" = ? and "version" = ?`)

    const result = stmt.run(
      account.parentId,
      account.commodityId,
      account.name,
      account.isPlaceholder ? 1 : 0,
      account.type,
      JSON.stringify(account.typeData),
      account.id,
      account.version
    )

    this.validateFn(result, account, "account")
    return account
  }

  delete(account) {
    const stmt = this.db.prepare(`
      DELETE FROM account
      WHERE "id" = ? AND "version" = ?`)

    const result = stmt.run(
      account.id,
      account.version
    )

    this.validateFn(result, account, "account")
  }
}
