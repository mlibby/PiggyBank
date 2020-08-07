exports.ApiKeyRepo = class ApiKeyRepo {
  constructor(db, validateFn) {
    this.db = db
    this.validateFn = validateFn
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        "id",
        "description",
        "value",
        "version"
      FROM api_key`)

    const results = stmt.all()
    return results
  }

  update(apiKey) {
    const stmt = this.db.prepare(`
      UPDATE apiKey 
      SET "description" = ?,
        "value" = ?
      WHERE "id" = ? and "version" = ?
      `)

    const result = stmt.run(
      apiKey.description,
      apiKey.value,
      apiKey.id,
      apiKey.version
    )

    this.validateFn(result, apiKey, "api_key")
    return apiKey
  }
}