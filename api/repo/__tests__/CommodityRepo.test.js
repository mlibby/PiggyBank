const { MockSQLite3 } = require("../__mocks__/SQLite3.mock")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { CommodityRepo } = require("../CommodityRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let mockCommodity
let repo
let db
let mockValidateFn
beforeEach(() => {
  mockCommodity = {
    id: 123,
    name: "test commodity",
    type: 1,
    symbol: "#",
    description: "description of test commodity",
    ticker: "TEST",
    version: origVersion
  }

  db = new SQLite3()
  mockValidateFn = jest.fn().mockImplementation((result, orig, table, idField) => {
    orig.version = newVersion
  })
  repo = new CommodityRepo(db, mockValidateFn)
})

test("new CommodityRepo(db)", () => {
  expect(repo.db).toBe(db)
})

test("selectAll() uses correct SQL and returns rows", () => {
  const mockResults = [{ foo: "foo", bar: "bar" }]
  db.all.mockReturnValue(mockResults)

  const commodities = repo.selectAll()
  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "id",
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

test("insert() uses correct SQL and returns updated commodity", () => {
  delete mockCommodity.id
  delete mockCommodity.version
  const mockId = 333
  db.run.mockReturnValue({
    changes: 1,
    lastInsertRowid: mockId
  })
  db.get.mockReturnValue({
    id: mockId,
    version: newVersion
  })

  const commodity = repo.insert(mockCommodity)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      INSERT INTO commodity (
        "name",
        "type",
        "symbol",
        "description",
        "ticker",
        "version"
      )
      VALUES (?, ?, ?, ?, ?, getVersion())`
    ))
  expect(db.run.mock.calls[0][0]).toEqual(mockCommodity.name)
  expect(db.run.mock.calls[0][1]).toEqual(mockCommodity.type)
  expect(db.run.mock.calls[0][2]).toEqual(mockCommodity.symbol)
  expect(db.run.mock.calls[0][3]).toEqual(mockCommodity.description)
  expect(db.run.mock.calls[0][4]).toEqual(mockCommodity.ticker)

  expect(commodity.id).toBe(mockId)
  expect(commodity.version).toBe(newVersion)
})
