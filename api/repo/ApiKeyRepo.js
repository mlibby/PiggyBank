exports.ApiKeyRepo = class ApiKeyRepo {
  constructor(queryFn) {
    this.queryFn = queryFn
  }

  async selectAll() {
    const sql = `
      SELECT
        api_key_id "id",
        description,
        api_key_value "apiKeyValue"
      FROM api_key`

    const results = await this.queryFn(sql)
    return results.rows
  }
}