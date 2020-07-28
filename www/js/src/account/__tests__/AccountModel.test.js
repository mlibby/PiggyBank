import { AccountModel } from "../AccountModel"

test("account model configuration", () => {
  const accountModel = new AccountModel()
  expect(accountModel.idAttribute).toBe("accountId")
  expect(accountModel.urlRoot).toBe("/api/account")
  expect(accountModel.children).toEqual([])
})