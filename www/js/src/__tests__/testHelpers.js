import { AccountCollection } from "../account/AccountCollection"
import { CommodityCollection } from "../commodity/CommodityCollection"

const mockTemplate = exports.mockTemplate = "htmlTemplate"
const mockHtml = exports.mockHtml = "renderedHtml"
const mockGuid = exports.mockGuid = "test guid"

jest.mock("../../lib/lit-html/lit-html.js", () => {
  return {
    html: jest.fn().mockImplementation(() => {
      return mockTemplate
    }),
    render: jest.fn().mockImplementation(() => {
      return mockHtml
    })
  }
})

jest.mock("../PiggyBankUtil", () => {
  return {
    getUuid: jest.fn().mockReturnValue(mockGuid)
  }
})

const collection = []
window.piggybank = {
  accounts: new AccountCollection({ collection: [] }),
  commodities: new CommodityCollection({ collection: [] })
}
