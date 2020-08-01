const { AccountRepo } = require("../AccountRepo")
const helpers = require("../../__tests__/testHelpers.js")
let queryFn = jest.fn()

const origMd5 = 'originalMd5'
const newMd5 = 'newMd5'
let testAccount

beforeEach(() => {
  testAccount = {
    accountId: 123,
    currencyId: 1,
    name: "test account",
    isPlaceholder: false,
    parentId: 1,
    md5: origMd5
  }
})

test("new AccountRepo(queryFn)", () => {
  const accountRepo = new AccountRepo(queryFn)
  expect(accountRepo.queryFn).toBe(queryFn)
})

test("selectAll() uses correct SQL and returns rows", () => {
  const results = { rows: ["foo", "bar"] }
  queryFn.mockResolvedValue(results)
  const accountRepo = new AccountRepo(queryFn)
  const accounts =  accountRepo.selectAll()
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
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

test("insert() uses correct SQL and returns updated account",  () => {
  delete testAccount.accountId
  delete testAccount.md5
  const accountId = 333
  queryFn = jest.fn().mockResolvedValue({
    rowCount: 1,
    rows:
      [{
        account_id: accountId,
        md5: newMd5
      }]
  })

  const accountRepo = new AccountRepo(queryFn)
  const account =  accountRepo.insert(testAccount)

  expect(helpers.normalize(queryFn.mock.calls[0][0]))
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
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId
  ])
  expect(account.accountId).toBe(accountId)
  expect(account.md5).toBe(newMd5)
})

test("update() uses correct SQL and returns updated account",  () => {
  queryFn = jest.fn().mockResolvedValue({
    rowCount: 1,
    rows:
      [{
        account_id: testAccount.accountId,
        md5: newMd5
      }]
  })

  const accountRepo = new AccountRepo(queryFn)
  const account = accountRepo.update(testAccount)

  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      UPDATE account 
      SET currency_id = $1,
        account_name = $2,
        is_placeholder = $3,
        parent_id = $4
      WHERE account_id = $5 and md5(account::text) = $6
      RETURNING *, md5(account::text)`
    ))
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId,
    testAccount.accountId,
    origMd5
  ])
  expect(account.md5).toBe(newMd5);
})

test("update() fails from stale snapshot of account", () => {
  queryFn = jest.fn().mockResolvedValueOnce({
    rowCount: 0,
    rows: []
  }).mockResolvedValueOnce({
    rowCount: 1,
    rows: [{
      accountId: testAccount.accountId,
      md5: newMd5
    }]
  })

  const accountRepo = new AccountRepo(queryFn)
  try {
    const account =  accountRepo.update(testAccount)
  }
  catch (e) {
    expect(e.message).toBe("md5 mismatch")
  }
})

test("update() fails because of missing record",  () => {
  queryFn = jest.fn().mockResolvedValueOnce({
    rowCount: 0,
    rows: []
  }).mockResolvedValue({
    rowCount: 0,
    rows: []
  })

  const accountRepo = new AccountRepo(queryFn)
  try {
    const account =  accountRepo.update(testAccount)
  }
  catch (e) {
    expect(e.message).toBe("id mismatch")
  }
})

test("delete() uses correct SQL",  () => {
  queryFn = jest.fn().mockResolvedValue({
    rowCount: 1,
    rows:
      [{
        account_id: testAccount.accountId,
        md5: origMd5
      }]
  })

  const accountRepo = new AccountRepo(queryFn)
  const result =  accountRepo.delete(testAccount)

  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      DELETE FROM account
      WHERE account_id = $1 and md5(account::text) = $2
      RETURNING *, md5(account::text)`
    ))
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.accountId,
    testAccount.md5
  ])
})

test("delete() fails from stale snapshot of account",  () => {
  queryFn = jest.fn().mockResolvedValueOnce({
    rowCount: 0,
    rows: []
  }).mockResolvedValueOnce({
    rowCount: 1,
    rows: [{
      accountId: testAccount.accountId,
      md5: newMd5
    }]
  })

  const accountRepo = new AccountRepo(queryFn)

  expect.assertions(1)
  try {
     accountRepo.delete(testAccount)
  }
  catch (e) {
    expect(e.message).toBe("md5 mismatch")
  }
})

test("delete() fails because of missing record",  () => {
  queryFn = jest.fn().mockResolvedValueOnce({
    rowCount: 0,
    rows: []
  }).mockResolvedValue({
    rowCount: 0,
    rows: []
  })

  const accountRepo = new AccountRepo(queryFn)

  expect.assertions(1);
  try {
     accountRepo.delete(testAccount);
  }
  catch (e) {
    expect(e.message).toBe("id mismatch");
  }
})