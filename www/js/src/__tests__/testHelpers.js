import { AccountCollection } from "../account/AccountCollection"
import { CommodityCollection } from "../commodity/CommodityCollection"

const mockGuid = exports.mockGuid = "test guid"
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