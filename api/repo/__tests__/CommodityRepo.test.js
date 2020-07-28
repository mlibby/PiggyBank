const CommodityRepo = require("../CommodityRepo")
const helpers = require("../../__tests__/testHelpers.js")
let queryFn = jest.fn()

test("new CommodityRepo(queryFn)", () => {
  const repo = new CommodityRepo(queryFn)
  expect(repo.queryFn).toBe(queryFn)
})

test("selectAll() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"] }
  queryFn.mockResolvedValue(results)
  const repo = new CommodityRepo(queryFn)
  const commodities = await repo.selectAll()
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        commodity_id "commodityId",
        commodity_type "type",
        symbol,
        "name",
        description,
        ticker
      FROM commodity`
    ))
  expect(commodities).toEqual(results.rows)
})