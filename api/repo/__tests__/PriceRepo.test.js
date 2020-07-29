const { PriceRepo } = require("../PriceRepo")
const helpers = require("../../__tests__/testHelpers.js")
let queryFn = jest.fn()

test("new PriceRepo(queryFn)", () => {
  const repo = new PriceRepo(queryFn)
  expect(repo.queryFn).toBe(queryFn)
})

test("selectAll() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"] }
  queryFn.mockResolvedValue(results)
  const repo = new PriceRepo(queryFn)
  const ofx = await repo.selectAll()
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
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
      ON p.currency_id = c2.commodity_id`
    ))
  expect(ofx).toEqual(results.rows)
})