const { MockSQLite3 } = require("./MockSQLite3")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { ApiKeyRepo } = require("../ApiKeyRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let repo
let db
beforeEach(() => {
  db = new SQLite3()
  repo = new ApiKeyRepo(db)
})

test("new ApiKeyRepo(queryFn)", () => {
  expect(repo.db).toBe(db)
})

test("selectAll() uses correct SQL and returns rows",  () => {
  const mockResults = [{foo: "foo", bar: "bar"}]
  db.all.mockReturnValue(mockResults)

  const apiKeys =  repo.selectAll()

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "apiKeyId",
        "description",
        "apiKeyValue",
        "version"
      FROM api_key`
    ))
  expect(apiKeys).toEqual(mockResults)
})