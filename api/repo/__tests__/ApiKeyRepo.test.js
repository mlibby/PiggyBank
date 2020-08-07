const { MockSQLite3 } = require("../__mocks__/SQLite3.mock")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { ApiKeyRepo } = require("../ApiKeyRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let repo
let db
let mockApiKey
let mockValidateFn
beforeEach(() => {
  db = new SQLite3()
  mockValidateFn = jest.fn().mockImplementation((result, orig, table) => {
    orig.version = newVersion
  })
  repo = new ApiKeyRepo(db, mockValidateFn)
  mockApiKey = {
    id: 423,
    description: "alphavantage",
    value: "beep boop bap",
    version: origVersion
  }
})

test("new ApiKeyRepo(db, validationFn)", () => {
  expect(repo.db).toBe(db)
  expect(repo.validateFn).toBe(mockValidateFn)
})

test("selectAll() uses correct SQL and returns rows", () => {
  const mockResults = [{ foo: "foo", bar: "bar" }]
  db.all.mockReturnValue(mockResults)

  const apiKeys = repo.selectAll()

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "id",
        "description",
        "value",
        "version"
      FROM api_key`
    ))
  expect(apiKeys).toEqual(mockResults)
})

test("update() uses correct SQL and returns updated account", () => {
  const mockChanges = { changes: 1 }
  db.run.mockReturnValue(mockChanges)
  db.get.mockReturnValue({
    version: newVersion
  })

  const apiKey = repo.update(mockApiKey)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      UPDATE apiKey 
      SET "description" = ?,
        "value" = ?
      WHERE "id" = ? and "version" = ?`
    ))
  expect(db.run.mock.calls[0][0]).toEqual(mockApiKey.description)
  expect(db.run.mock.calls[0][1]).toEqual(mockApiKey.value)
  expect(db.run.mock.calls[0][2]).toEqual(mockApiKey.id)
  expect(db.run.mock.calls[0][3]).toEqual(origVersion)
  expect(mockValidateFn).toHaveBeenCalledWith(mockChanges, mockApiKey, "api_key")
  expect(apiKey.version).toBe(newVersion)
})