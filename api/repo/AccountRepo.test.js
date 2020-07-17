const AccountRepo = require("./AccountRepo");
const helpers = require("../testHelpers.js");
let queryFn = jest.fn();

test("new AccountRepo(queryFn)", () => {
  const accountRepo = new AccountRepo(queryFn);
  expect(accountRepo.queryFn).toBe(queryFn);
});

test("accountRepo.selectAll() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"] };
  queryFn.mockResolvedValue(results);
  const accountRepo = new AccountRepo(queryFn);
  const accounts = await accountRepo.selectAll();
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(
      `SELECT
        account_id "accountId",
        currency_id "currencyId",
        account_name "name",
        is_placeholder "isPlaceholder",
        parent_id "parentId"
      FROM account`
    ));
  expect(accounts).toEqual(results.rows);
});

test("accountRepo.insert() uses correct SQL and returns updated account", async () => {
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
    .toBe(helpers.normalize(
      `INSERT INTO account (
      currency_id,
      account_name,
      is_placeholder,
      parent_id
    )
    VALUES ($1, $2, $3, $4)
    RETURNING *`
    ));
  expect(queryFn.mock.calls[0][1]).toEqual([
    testAccount.currencyId,
    testAccount.name,
    testAccount.isPlaceholder,
    testAccount.parentId
  ]);
  expect(account.accountId).toBe(testAccountId);
});