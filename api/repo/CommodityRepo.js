class CommodityRepo {
  constructor(queryFn) {
    this.queryFn = queryFn
  }

  async selectAll() {
    const sql = `
    SELECT
      commodity_id "commodityId",
      commodity_type "type",
      symbol,
      "name",
      description,
      ticker
    FROM commodity`

    const results = await this.queryFn(sql)
    return results.rows
  }
}

module.exports = CommodityRepo