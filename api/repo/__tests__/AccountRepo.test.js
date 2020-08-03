const { MockSQLite3 } = require("./MockSQLite3")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const { AccountRepo } = require("../AccountRepo.js")
const helpers = require("../../__tests__/testHelpers.js")

const origVersion = 'original version'
const newVersion = 'new version'

let testAccount
let accountRepo
let db
beforeEach(() => {
  testAccount = {
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

// test("new AccountRepo(queryFn)", () => {
//   expect(accountRepo.queryFn).toBe(queryFn)
// })

test("selectAll() uses correct SQL and returns rows", () => {
  const accounts = accountRepo.selectAll()
  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        account_id "accountId",
        currency_id "currencyId",
        account_name "name",
        is_placeholder "isPlaceholder",
        parent_id "parentId",
        md5(account::text) "md5"
      FROM account`
    ))
  expect(accounts).toEqual(results.rows)
})

test("insert() uses correct SQL and returns updated account", () => {
  delete testAccount.accountId
  delete testAccount.md5
  const accountId = 333
  db.get = jest.fn()
  .mockReturnValue({
    rowCount: 1,
    rows:
      [{
        account_id: accountId,
        md5: newVersion
      }]
  })

  const account = accountRepo.insert(testAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      INSERT INTO account (
        currency_id,
        account_name,
        is_placeholder,
        parent_id
      )
      VALUES ($1, $2, $3, $4)
      RETURNING *, md5(account::text)`
    ))
  expect(db.get.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId
  ])
  expect(account.accountId).toBe(accountId)
  expect(account.md5).toBe(newVersion)
})

test("update() uses correct SQL and returns updated account", () => {
  db.get = jest.fn().mockReturnValue({
    rowCount: 1,
    rows:
      [{
        account_id: testAccount.accountId,
        md5: newVersion
      }]
  })

  const account = accountRepo.update(testAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      UPDATE account 
      SET currency_id = $1,
        account_name = $2,
        is_placeholder = $3,
        parent_id = $4
      WHERE account_id = $5 and md5(account::text) = $6
      RETURNING *, md5(account::text)`
    ))
  expect(db.get.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId,
    testAccount.accountId,
    origVersion
  ])
  expect(account.md5).toBe(newVersion);
})

test("update() fails from stale snapshot of account", () => {
  db.get = jest.fn().mockReturnValueOnce({
    rowCount: 0,
    rows: []
  }).mockReturnValueOnce({
    rowCount: 1,
    rows: [{
      accountId: testAccount.accountId,
      md5: newVersion
    }]
  })

  try {
    const account = accountRepo.update(testAccount)
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
    const account = accountRepo.update(testAccount)
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
          account_id: testAccount.accountId,
          md5: origVersion
        }]
    })

  const result = accountRepo.delete(testAccount)

  expect(helpers.normalize(db.prepare.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      DELETE FROM account
      WHERE account_id = $1 and md5(account::text) = $2
      RETURNING *, md5(account::text)`
    ))
  expect(db.get.mock.calls[0][1]).toEqual([
    testAccount.accountId,
    testAccount.md5
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
        accountId: testAccount.accountId,
        md5: newVersion
      }]
    })

  expect.assertions(1)
  try {
    accountRepo.delete(testAccount)
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
    accountRepo.delete(testAccount);
  }
  catch (e) {
    expect(e.message).toBe("id mismatch");
  }
})