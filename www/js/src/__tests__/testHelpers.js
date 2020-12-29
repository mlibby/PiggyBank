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
  currencyId: 1,
  name: "Assets",
  isPlaceholder: 1,
  parentId: null
})

const mockAccountSavings = exports.mockAccountSavings = new AccountModel({
  id: 2,
  currencyId: 1,
  name: "Savings",
  isPlaceholder: 0,
  parentId: 1
})

const mockAccountChecking = exports.mockAccountChecking = new AccountModel({
  id: 3,
  currencyId: 1,
  name: "Checking",
  isPlaceholder: 0,
  parentId: 1
})

const mockAccountInvestments = exports.mockAccountInvestments = new AccountModel({
  id: 4,
  currencyId: 1,
  name: "Investments",
  isPlaceholder: 1,
  parentId: 1
})

const mockAccount401k = exports.mockAccount401k = new AccountModel({
  id: 5,
  currencyId: 1,
  name: "401k",
  isPlaceholder: 0,
  parentId: 4
})

const mockAccountLiabilities = exports.mockAccountLiabilities = new AccountModel({
  id: 10,
  currencyId: 1,
  name: "Liabilities",
  isPlaceholder: 1,
  parentId: null
})

const mockAccountCarLoan = exports.mockAccountCarLoan = new AccountModel({
  id: 11,
  currencyId: 1,
  name: "Car Loan",
  isPlaceholder: 0,
  parentId: 10
})

const mockAccountMortgage = exports.mockAccountMortgage = new AccountModel({
  id: 12,
  currencyId: 1,
  name: "Mortgage",
  isPlaceholder: 0,
  parentId: 10
})

const accounts = exports.mockAccounts = new AccountCollection([
  mockAccountAssets,
  mockAccountSavings,
  mockAccountChecking,
  mockAccountInvestments,
  mockAccount401k,
  mockAccountLiabilities,
  mockAccountCarLoan,
  mockAccountMortgage
])
accounts.unflatten()

const commodities = exports.mockCommodities = new CommodityCollection({ collection: [] })

window.piggybank = { accounts, commodities }

const mockModal = jest.fn()
const mockHtml = jest.fn()
const mockVal = jest.fn()
const mock$ = exports.mock$ = {
  0: { checked: true },
  modal: mockModal,
  html: mockHtml,
  val: mockVal
}