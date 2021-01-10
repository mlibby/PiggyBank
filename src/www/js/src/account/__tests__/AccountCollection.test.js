import { mockAccounts } from "../../__tests__/testHelpers"
import { AccountModel } from "../AccountModel"

test("new AccountCollection()", () => {
  expect(mockAccounts.model).toBe(AccountModel)
  expect(mockAccounts.url).toBe("/api/account")
  expect(mockAccounts.comparator).toBe("name")
})

test("unflatten accounts from api", () => {
  const assets = mockAccounts.models[0]
  expect(assets.get("name")).toBe("Assets")
  expect(assets.longName()).toBe("Assets")
  expect(assets.children.models.length).toBe(3)

  const liabilities = mockAccounts.models[1]
  expect(liabilities.get("name")).toBe("Liabilities")

  const investments = assets.children.models[1]
  expect(investments.get("name")).toBe("Investments")
  expect(investments.longName()).toBe("Assets::Investments")
  expect(investments.children.models.length).toBe(1)

  const k401 = investments.children.models[0]
  expect(k401.get("name")).toBe("401k")
  expect(k401.longName()).toBe("Assets::Investments::401k")
})