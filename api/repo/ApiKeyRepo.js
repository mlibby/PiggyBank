exports.ApiKeyRepo = class ApiKeyRepo {
  constructor(db, validateFn) {
    this.db = db
    this.validateFn = validateFn
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

  update(apiKey) {
    const stmt = this.db.prepare(`
      UPDATE apiKey 
      SET "description" = ?,
        "apiKeyValue" = ?
      WHERE "apiKeyId" = ? and "version" = ?
      `)

    const result = stmt.run(
      apiKey.description,
      apiKey.apiKeyValue,
      apiKey.apiKeyId,
      apiKey.version
    )

    this.validateFn(result, apiKey, "api_key", "apiKeyId")
    return apiKey
  }
}