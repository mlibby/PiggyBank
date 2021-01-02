"use strict"

exports.CommodityRepo = class CommodityRepo {
  constructor(db, validateFn) {
    this.db = db
    this.validateFn = validateFn
  }

  select(id) {
    const stmt = this.db.prepare(`
      SELECT
        "id",
        "name",
        "type",
        "description",
        "ticker",
        "fraction",
        "version"
      FROM commodity`)

    const result = stmt.get()
    return result
  }

  selectAll() {
    const stmt = this.db.prepare(`
    SELECT
      "id",
      "type",
      "name",
      "description",
      "ticker",
      "fraction",
      "version"
    FROM commodity`)

    const results = stmt.all()
    return results
  }

  insert(commodity) {
    const stmt = this.db.prepare(`
      INSERT INTO commodity (
        "name",
        "type",
        "description",
        "ticker",
        "fraction",
        "version"
      )
      VALUES (?, ?, ?, ?, ?, getVersion())
      `)

    const result = stmt.run(
      commodity.name,
      commodity.type,
      commodity.description,
      commodity.ticker,
      commodity.fraction,
      commodity.locale
    )

    commodity = this.select(result.lastInsertRowid)
    return commodity
  }
}