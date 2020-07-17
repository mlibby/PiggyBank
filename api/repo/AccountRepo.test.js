const AccountRepo = require("./AccountRepo");
const helpers = require("../testHelpers.js");
let queryFn = jest.fn();

test("new AccountRepo(queryFn)", () => {
  const accountRepo = new AccountRepo(queryFn);
  expect(accountRepo.queryFn).toBe(queryFn);
});

test("selectAll() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"] };
  queryFn.mockResolvedValue(results);
  const accountRepo = new AccountRepo(queryFn);
  const accounts = await accountRepo.selectAll();
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
    ));
  expect(accounts).toEqual(results.rows);
});

test("insert() uses correct SQL and returns updated account", async () => {
  const testAccount = {
    currencyId: 1,
    name: "test account",
    isPlaceholder: false,
    parentId: 1
  };
  const testAccountId = 4;
  queryFn = jest.fn().mockResolvedValue({ rows: [{ account_id: testAccountId }] });

  const accountRepo = new AccountRepo(queryFn);
  const account = await accountRepo.insert(testAccount);

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
    ));
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId
  ]);
  expect(account.accountId).toBe(testAccountId);
});

test("update() uses correct SQL and returns account", async () => {
  const testAccount = {
    accountId: 123,
    currencyId: 1,
    name: "test account",
    isPlaceholder: false,
    parentId: 1,
    md5: 'md5(account::text)',
  };

  const accountRepo = new AccountRepo(queryFn);
  await accountRepo.update(testAccount);

  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      UPDATE account 
      SET currency_id = $1,
        account_name = $2,
        is_placeholder = $3,
        parent_id = $4
      WHERE account_id = $5 and md5(account::text) = $6
      RETURNING *, md5(account::text)`
    ));
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId,
    testAccount.accountId,
    testAccount.md5
  ]);
});

test("delete() uses correct SQL", async () => {
  const testAccount = {
    accountId: 123,
    currencyId: 1,
    name: "test account",
    isPlaceholder: false,
    parentId: 1,
    md5: '9f2cfe1c5a1582fd631d80fa25d6cb5d'
  };

  const accountRepo = new AccountRepo(queryFn);
  const result = await accountRepo.delete(testAccount);

  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      DELETE FROM account
      WHERE account_id = $1 and md5(account::text) = $2`
    ));
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.accountId,
    testAccount.md5
  ]);
});
