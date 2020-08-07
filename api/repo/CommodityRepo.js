exports.CommodityRepo = class CommodityRepo {
  constructor(db) {
    this.db = db
  }

  selectAll() {
    const stmt = this.db.prepare(`
    SELECT
      "id",
      "type",
      "symbol",
      "name",
      "description",
      "ticker",
      "version"
    FROM commodity`)

    const results = stmt.all()
    return results
  }
}