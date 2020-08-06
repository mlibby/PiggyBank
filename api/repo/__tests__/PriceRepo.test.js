const { MockSQLite3 } = require("../__mocks__/SQLite3.mock")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { PriceRepo } = require("../PriceRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let repo
let db
beforeEach(() => {
  db = new SQLite3()
  repo = new PriceRepo(db)
})

test("new PriceRepo(db)", () => {
  expect(repo.db).toBe(db)
})

test("selectAll() uses correct SQL and returns rows", () => {
  const mockResults = [{foo: "foo", bar: "bar"}]
  db.all.mockReturnValue(mockResults)

  const prices = repo.selectAll()

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "priceId",
        "currencyId",
        cur.name "currencyName",
        p.commodityId "commodityId",
        com.name "commodityName",
        "value",
        "quoteDate"
      FROM price p
      JOIN commodity com
      ON p.commodityId = cur.commodityId
      JOIN commodity cur
      ON p.currencyId = cur.commodityId`
    ))
  expect(prices).toEqual(mockResults)
})