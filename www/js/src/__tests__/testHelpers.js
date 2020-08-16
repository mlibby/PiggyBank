import { AccountModel } from "../account/AccountModel"
import { AccountCollection } from "../account/AccountCollection"
import { CommodityCollection } from "../commodity/CommodityCollection"

const mockGuid = exports.mockGuid = "test guid"
jest.mock("../PiggyBankUtil", () => {
  return {
    getUuid: jest.fn().mockReturnValue(mockGuid)
  }
})

const mockAccountAssets = exports.mockAccountAssets = new AccountModel({
  id: 1,
  commodityId: 1,
  name: "mock assets",
  isPlaceholder: 1,
  parentId: null
})

const mockAccountSavings = exports.mockAccountSavings = new AccountModel({
  id: 2,
  commodityId: 1,
  name: "mock savings",
  isPlaceholder: 0,
  parentId: 1
})

const mockAccountExpenses = exports.mockAccountExpenses = new AccountModel({
  id: 3,
  commodityId: 1,
  name: "mock expenses",
  isPlaceholder: 1,
  parentId: null
})

const accounts = exports.mockAccounts = new AccountCollection({
  collection: [
    mockAccountAssets,
    mockAccountExpenses,
    mockAccountSavings
  ]
})
accounts.unflatten()

const commodities = exports.mockCommodities = new CommodityCollection({ collection: [] })

window.piggybank = { accounts, commodities }