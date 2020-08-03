const { MockSQLite3 } = require("./MockSQLite3")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { AccountRepo } = require("../AccountRepo.js")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let mockAccount
let accountRepo
let db
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
  accountRepo = new AccountRepo(db)
})

test("new AccountRepo(db)", () => {
  expect(accountRepo.db).toBe(db)
})

test("selectAll() uses correct SQL and returns rows", () => {
  db.all.mockReturnValue([mockAccount])
  const accounts = accountRepo.selectAll()
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

  const account = accountRepo.insert(mockAccount)

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
  db.run.mockReturnValue({
    changes: 1
  })
  db.get.mockReturnValue({
    version: newVersion
  })

  const account = accountRepo.update(mockAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      UPDATE account 
      SET "currencyId" = ?,
        "accountName" = ?,
        "isPlaceholder" = ?,
        "parentId" = ?
      WHERE "accountId" = ? and "version" = ?`
    ))
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.currencyId)
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.name)
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.isPlaceholder)
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.parentId)
  expect(db.run.mock.calls[0][0]).toEqual(mockAccount.accountId)
  expect(db.run.mock.calls[0][0]).toEqual(origVersion)
  expect(account.version).toBe(newVersion);
})

test("update() fails from stale snapshot of account", () => {
  db.get = jest.fn().mockReturnValueOnce({
    rowCount: 0,
    rows: []
  }).mockReturnValueOnce({
    rowCount: 1,
    rows: [{
      accountId: mockAccount.accountId,
      md5: newVersion
    }]
  })

  try {
    const account = accountRepo.update(mockAccount)
  }
  catch (e) {
    expect(e.message).toBe("md5 mismatch")
  }
})

test("update() fails because of missing record", () => {
  db.get = jest.fn()
    .mockReturnValueOnce({
      rowCount: 0,
      rows: []
    })
    .mockReturnValue({
      rowCount: 0,
      rows: []
    })

  try {
    const account = accountRepo.update(mockAccount)
  }
  catch (e) {
    expect(e.message).toBe("id mismatch")
  }
})

test("delete() uses correct SQL", () => {
  db.get = jest.fn()
    .mockReturnValue({
      rowCount: 1,
      rows:
        [{
          account_id: mockAccount.accountId,
          md5: origVersion
        }]
    })

  const result = accountRepo.delete(mockAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      DELETE FROM account
      WHERE account_id = $1 and md5(account::text) = $2
      RETURNING *, md5(account::text)`
    ))
  expect(db.get.mock.calls[0][1]).toEqual([
    mockAccount.accountId,
    mockAccount.md5
  ])
})

test("delete() fails from stale snapshot of account", () => {
  db.get = jest.fn()
    .mockReturnValueOnce({
      rowCount: 0,
      rows: []
    })
    .mockReturnValueOnce({
      rowCount: 1,
      rows: [{
        accountId: mockAccount.accountId,
        md5: newVersion
      }]
    })

  expect.assertions(1)
  try {
    accountRepo.delete(mockAccount)
  }
  catch (e) {
    expect(e.message).toBe("version mismatch")
  }
})

test("delete() fails because of missing record", () => {
  db.get = jest.fn()
    .mockReturnValueOnce({
      rowCount: 0,
      rows: []
    })
    .mockReturnValue({
      rowCount: 0,
      rows: []
    })

  expect.assertions(1);
  try {
    accountRepo.delete(mockAccount);
  }
  catch (e) {
    expect(e.message).toBe("id mismatch");
  }
})