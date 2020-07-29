exports.PriceRepo = class PriceRepo {
  constructor(queryFn) {
    this.queryFn = queryFn
  }

  async selectAll() {
    const sql = `
      SELECT
        price_id "id",
        currency_id "currencyId",
        c2.name "currencyName",
        p.commodity_id "commodityId",
        c.name "commodityName",
        "value",
        quote_date "quoteDate"
      FROM price p
      JOIN commodity c 
      ON p.commodity_id = c.commodity_id
      JOIN commodity c2
      ON p.currency_id = c2.commodity_id
      `

    const results = await this.queryFn(sql)
    return results.rows
  }
}