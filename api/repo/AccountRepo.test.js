const AccountRepo = require("./AccountRepo");
let queryFn = jest.fn();

test("new AccountRepo(queryFn)", () => {
  const accountRepo = new AccountRepo(queryFn);
  expect(accountRepo.queryFn).toBe(queryFn);
});