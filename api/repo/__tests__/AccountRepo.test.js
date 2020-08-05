const { MockSQLite3 } = require("./MockSQLite3")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { AccountRepo } = require("../AccountRepo.js")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = "original version"
const newVersion = "new version"

let mockAccount
let repo
let db
let mockValidateFn
beforeEach(() => {
  mockAccount = {
    accountId: 123,
    currencyId: 1,
    name: "test account",
    isPlaceholder: false,
    parentId: 1,
    version: origVersion
  }

  db = new SQLite3()
  mockValidateFn = jest.fn().mockImplementation((result, orig, table, idField) => {
    orig.version = newVersion
  })
  repo = new AccountRepo(db, mockValidateFn)
})

test("new AccountRepo(db)", () => {
  expect(repo.db).toBe(db)
  expect(repo.validateFn).toBe(mockValidateFn)
})

test("selectAll() uses correct SQL and returns rows", () => {
  db.all.mockReturnValue([mockAccount])
  const accounts = repo.selectAll()
  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        "accountId",
        "currencyId",
        "name",
        "isPlaceholder",
        "parentId",
        "version"
      FROM account`
    ))
  expect(accounts).toEqual([mockAccount])
})

test("insert() uses correct SQL and returns updated account", () => {
  delete mockAccount.accountId
  delete mockAccount.md5
  const mockAccountId = 333
  db.run.mockReturnValue({
    changes: 1,
    lastInsertRowid: mockAccountId
  })
  db.get.mockReturnValue({
    accountId: mockAccountId,
    version: newVersion
  })

  const account = repo.insert(mockAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      INSERT INTO account (
        "currencyId",
        "name",
        "isPlaceholder",
        "parentId",
        "version"
      )
      VALUES (?, ?, ?, ?, getVersion())`
    ))
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.currencyId)
  expect(db.run.mock.calls[0][1]).toEqual(mockAccount.name)
  expect(db.run.mock.calls[0][2]).toEqual(mockAccount.isPlaceholder)
  expect(db.run.mock.calls[0][3]).toEqual(mockAccount.parentId)

  expect(account.accountId).toBe(mockAccountId)
  expect(account.version).toBe(newVersion)
})

test("update() uses correct SQL and returns updated account", () => {
  const mockChanges = { changes: 1 }
  db.run.mockReturnValue(mockChanges)
  db.get.mockReturnValue({ version: newVersion })

  const account = repo.update(mockAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      UPDATE account 
      SET "currencyId" = ?,
        "name" = ?,
        "isPlaceholder" = ?,
        "parentId" = ?
      WHERE "accountId" = ? and "version" = ?`
    ))
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.currencyId)
  expect(db.run.mock.calls[0][1]).toEqual(mockAccount.name)
  expect(db.run.mock.calls[0][2]).toEqual(mockAccount.isPlaceholder)
  expect(db.run.mock.calls[0][3]).toEqual(mockAccount.parentId)
  expect(db.run.mock.calls[0][4]).toEqual(mockAccount.accountId)
  expect(db.run.mock.calls[0][5]).toEqual(origVersion)
  expect(mockValidateFn).toBeCalledWith(mockChanges, mockAccount, "account", "accountId")
  expect(account.version).toEqual(newVersion)
})


test("delete() uses correct SQL", () => {
  const mockChanges = { changes: 1 }
  db.run.mockReturnValue(mockChanges)
  db.get.mockReturnValue(undefined)

  const result = repo.delete(mockAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      DELETE FROM account
      WHERE "accountId" = ? AND "version" = ?`
    ))
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.accountId)
  expect(db.run.mock.calls[0][1]).toEqual(origVersion)
  expect(mockValidateFn).toBeCalledWith(mockChanges, mockAccount, "account", "accountId")
})
