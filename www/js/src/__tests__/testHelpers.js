import { AccountModel } from "../account/AccountModel"
import { AccountCollection } from "../account/AccountCollection"
import { CommodityCollection } from "../commodity/CommodityCollection"
import { ApiKeyModel } from "../banking/ApiKeyModel"
import { ApiKeyCollection } from "../banking/ApiKeyCollection"
import { CommodityModel } from "../commodity/CommodityModel"

const mockGuid = exports.mockGuid = "test guid"
jest.mock("../PiggyBankUtil", () => {
  return {
    getUuid: jest.fn().mockReturnValue(mockGuid)
  }
})

const mockAccountAssets = exports.mockAccountAssets = new AccountModel({
  id: 1,
  commodityId: 1,
  name: "Assets",
  isPlaceholder: 1,
  parentId: null,
  type: 1,
  typeData: "{}"
})

const mockAccountSavings = exports.mockAccountSavings = new AccountModel({
  id: 2,
  commodityId: 1,
  name: "Savings",
  isPlaceholder: 0,
  parentId: 1,
  type: 1,
  typeData: "{}"
})

const mockAccountChecking = exports.mockAccountChecking = new AccountModel({
  id: 3,
  commodityId: 1,
  name: "Checking",
  isPlaceholder: 0,
  parentId: 1,
  type: 1,
  typeData: "{}"
})

const mockAccountInvestments = exports.mockAccountInvestments = new AccountModel({
  id: 4,
  commodityId: 1,
  name: "Investments",
  isPlaceholder: 1,
  parentId: 1,
  type: 1,
  typeData: "{}"
})

const mockAccount401k = exports.mockAccount401k = new AccountModel({
  id: 5,
  commodityId: 1,
  name: "401k",
  isPlaceholder: 0,
  parentId: 4,
  type: 1,
  typeData: "{}"
})

const mockAccountLiabilities = exports.mockAccountLiabilities = new AccountModel({
  id: 10,
  commodityId: 1,
  name: "Liabilities",
  isPlaceholder: 1,
  parentId: null,
  type: 5,
  typeData: "{}"
})

const mockAccountCarLoan = exports.mockAccountCarLoan = new AccountModel({
  id: 11,
  commodityId: 1,
  name: "Car Loan",
  isPlaceholder: 0,
  parentId: 10,
  type: 5,
  typeData: "{}"
})

const mockAccountMortgage = exports.mockAccountMortgage = new AccountModel({
  id: 12,
  commodityId: 1,
  name: "Mortgage",
  isPlaceholder: 0,
  parentId: 10,
  type: 6,
  typeData: "{}"
})

const mockAccounts = exports.mockAccounts = new AccountCollection([
  mockAccountAssets,
  mockAccountSavings,
  mockAccountChecking,
  mockAccountInvestments,
  mockAccount401k,
  mockAccountLiabilities,
  mockAccountCarLoan,
  mockAccountMortgage
])
mockAccounts.unflatten()

const mockApiKeyAlpha = exports.mockApiKeyAlpha = new ApiKeyModel({
  id: 13,
  description: "AlphaVantage",
  value: "xyz123"
})

const mockApiKeys = exports.mockApiKeys = new ApiKeyCollection([
  mockApiKeyAlpha
])

const mockCommodityUSD = exports.mockCommodityUSD = new CommodityModel({
  name: "USD",
  type: 0,
  symbol: "$",
  description: "US Dollar",
  ticker: "",
})

const mockCommodities = exports.mockCommodities = new CommodityCollection({
  collection: [mockCommodityUSD]
})

window.piggybank = {
  accounts: mockAccounts,
  commodities: mockCommodities
}

window.URL = {
  createObjectURL: jest.fn(),
  revokeObjectURL: jest.fn()
}

navigator.mediaDevices = {
  getUserMedia: jest.fn().mockResolvedValue("")
}

const mockAppend = jest.fn()
const mockModal = jest.fn()
const mockHtml = jest.fn()
const mockVal = jest.fn()
const mock$ = exports.mock$ = jest.fn().mockReturnValue({
  0: { checked: true },
  append: mockAppend,
  modal: mockModal,
  html: mockHtml,
  val: mockVal
})

const mockEvent = exports.mockEvent = {
  preventDefault: jest.fn()
}