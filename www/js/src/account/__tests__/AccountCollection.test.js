import { AccountCollection } from "../AccountCollection"
import { AccountModel } from "../AccountModel"

let accounts
beforeEach(() => {
  accounts = new AccountCollection([
    { id: 1, currencyId: 1, name: "Assets", isPlaceholder: 1, parentId: null },
    { id: 2, currencyId: 1, name: "Savings", isPlaceholder: 0, parentId: 1 },
    { id: 3, currencyId: 1, name: "Checking", isPlaceholder: 0, parentId: 1 },
    { id: 4, currencyId: 1, name: "Investments", isPlaceholder: 1, parentId: 1 },
    { id: 5, currencyId: 1, name: "401k", isPlaceholder: 0, parentId: 4 },

    { id: 10, currencyId: 1, name: "Liabilities", isPlaceholder: 1, parentId: null },
    { id: 11, currencyId: 1, name: "Car Loan", isPlaceholder: 0, parentId: 10 },
    { id: 12, currencyId: 1, name: "Mortgage", isPlaceholder: 0, parentId: 10 }
  ])
})

test("new AccountCollection()", () => {
  expect(accounts.model).toBe(AccountModel)
  expect(accounts.url).toBe("/api/account")
  expect(accounts.comparator).toBe("name")
})

test("unflatten accounts from api", () => {
  accounts.unflatten()

  const assets = accounts.models[0]
  expect(assets.get("name")).toBe("Assets")
  expect(assets.longName()).toBe("Assets")
  expect(assets.children.models.length).toBe(3)

  const liabilities = accounts.models[1]
  expect(liabilities.get("name")).toBe("Liabilities")

  const investments = assets.children.models[1]
  expect(investments.get("name")).toBe("Investments")
  expect(investments.longName()).toBe("Assets::Investments")
  expect(investments.children.models.length).toBe(1)

  const k401 = investments.children.models[0]
  expect(k401.get("name")).toBe("401k")
  expect(k401.longName()).toBe("Assets::Investments::401k")
})