const AccountRepo = require("./AccountRepo");
const helpers = require("../testHelpers.js");
let queryFn = jest.fn();

test("new AccountRepo(queryFn)", () => {
  const accountRepo = new AccountRepo(queryFn);
  expect(accountRepo.queryFn).toBe(queryFn);
});

test("accountRepo.all() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"]};
  queryFn.mockResolvedValue(results);
  const accountRepo = new AccountRepo(queryFn);
  const accounts = await accountRepo.all();
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe( helpers.normalize(
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