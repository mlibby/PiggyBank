const { MockSQLite3 } = require("./MockSQLite3")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { CommodityRepo } = require("../CommodityRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let repo
let db
beforeEach(() => {
  db = new SQLite3()
  repo = new CommodityRepo(db)
})

test("new CommodityRepo(db)", () => {
  expect(repo.db).toBe(db)
})

test("selectAll() uses correct SQL and returns rows", () => {
  const mockResults = [{foo: "foo", bar: "bar"}]
  db.all.mockReturnValue(mockResults)

  const commodities = repo.selectAll()
  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "commodityId",
        "type",
        "symbol",
        "name",
        "description",
        "ticker",
        "version"
      FROM commodity`
    ))
  expect(commodities).toEqual(mockResults)
})