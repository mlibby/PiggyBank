const { MockSQLite3 } = require("../__mocks__/SQLite3.mock")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { OfxRepo } = require("../OfxRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let repo
let db
beforeEach(() => {
  db = new SQLite3()
  repo = new OfxRepo(db)
})

test("new OfxRepo(db)", () => {
  expect(repo.db).toBe(db)
})

test("selectAll() uses correct SQL and returns rows", () => {
  const mockResults = [{foo: "foo", bar: "bar"}]
  db.all.mockReturnValue(mockResults)

  const ofx = repo.selectAll()
  
  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "ofxId",
        "active",
        "accountId",
        "url",
        "user",
        "password",
        "fid",
        "fidOrg",
        "bankId",
        "bankAccountId",
        "accountType",
        "version"
      FROM ofx`
    ))
  expect(ofx).toEqual(mockResults)
})