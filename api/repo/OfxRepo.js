exports.OfxRepo = class OfxRepo {
  constructor(db) {
    this.db = db
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        "id",
        "active",
        "accountId",
        "url",
        "user",
        "password",
        "fid",
        "fidOrg",
        "bankId",
        "bankAccountId",
        "accountType",
        "version"
      FROM ofx`)

    const results = stmt.all()
    return results
  }
}