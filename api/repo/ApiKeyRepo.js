exports.ApiKeyRepo = class ApiKeyRepo {
  constructor(db) {
    this.db = db
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        "apiKeyId",
        "description",
        "apiKeyValue",
        "version"
      FROM api_key`)

    const results = stmt.all()
    return results
  }
}