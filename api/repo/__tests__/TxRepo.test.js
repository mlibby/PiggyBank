const { MockSQLite3 } = require("../__mocks__/SQLite3.mock")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { TxRepo } = require("../TxRepo")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let repo
let db
beforeEach(() => {
  db = new SQLite3()
  repo = new TxRepo(db)
})


test("new TxRepo(db)", () => {
  expect(repo.db).toBe(db)
})

test("txRepo.selectAll() uses correct SQL and returns rows", async () => {
  const mockResults = [
    {
      txId: 2,
      postDate: "2020-02-20",
      number: "345",
      description: "Foo Bar",
      txVersion: "txVersion1",
      splitId: 1,
      accountId: 10,
      commodityId: 2,
      memo: "Foo",
      amount: 22.22,
      value: 66.66,
      splitVersion: "splitVersion1"
    },
    {
      txId: 2,
      postDate: "2020-02-20",
      number: "345",
      description: "Foo Bar",
      txVersion: "txVersion1",
      splitId: 2,
      accountId: 9,
      commodityId: 1,
      memo: "Bar",
      amount: -66.66,
      value: -66.66,
      splitVersion: "splitVersion2"
    }
  ]
  db.all.mockReturnValue(mockResults)

  const tx = repo.selectAll()

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        t."txId",
        t."postDate",
        t."number",
        t."description",
        t."version" "txVersion"
        s."splitId",
        s."accountId",
        s."commodityId",
        s."memo",
        s."amount",
        s."value",
        s."version" "splitVersion"
      FROM tx t
      JOIN split s
      ON t."txId = s."txId"
      ORDER BY t."txId", s."splitId"`
    ))

  expect(tx.length).toBe(1)
  expect(tx[0].id).toBe(2)
  expect(tx[0].postDate).toBe("2020-02-20")
  expect(tx[0].description).toBe("Foo Bar")
  expect(tx[0].version).toBe("txVersion1")
  expect(tx[0].splits.length).toBe(2)
  expect(tx[0].splits).toContainEqual({
    splitId: 2,
    accountId: 9,
    commodityId: 1,
    memo: "Bar",
    amount: -66.66,
    value: -66.66,
    version: "splitVersion2"
  })
  expect(tx[0].splits).toContainEqual({
    splitId: 1,
    accountId: 10,
    commodityId: 2,
    memo: "Foo",
    amount: 22.22,
    value: 66.66,
    version: "splitVersion1"
  })
})