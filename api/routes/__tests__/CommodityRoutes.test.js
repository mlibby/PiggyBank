const { CommodityRoutes } = require("../CommodityRoutes")
const helpers = require("../../__tests__/testHelpers.js")

const mockRouter = helpers.mockRouter()
const mockRepo = helpers.mockRepo()
const mockRequest = helpers.mockRequest()
mockRequest.fields.name = "MOCK"
mockRequest.fields.type = 1
mockRequest.fields.symbol = "M"
mockRequest.fields.description = "Mock Currency"
mockRequest.fields.ticker = "MOCK"
const mockResponse = helpers.mockResponse()

const mockCommodityOrig = {
  name: mockRequest.fields.name,
  type: mockRequest.fields.type,
  symbol: mockRequest.fields.symbol,
  description: mockRequest.fields.description,
  ticker: mockRequest.fields.ticker
}
const mockCommodityId = 890
const mockCommodityVersion = "mock version 2"
const mockCommodityNew = Object.assign({
  id: mockCommodityId,
  version: mockCommodityVersion
}, mockCommodityOrig)

test("new CommodityRoutes(router, repo)", () => {
  const routes = new CommodityRoutes(mockRouter, mockRepo)
  expect(routes.repo).toBe(mockRepo)
})

test("sets up routes", () => {
  const routes = new CommodityRoutes(mockRouter, mockRepo)
  expect(mockRouter.get.mock.calls[0][0]).toBe("/")
  expect(mockRouter.post.mock.calls[0][0]).toBe("/")
  // expect(mockRouter.put.mock.calls[0][0]).toBe("/:id")
  // expect(mockRouter.delete.mock.calls[0][0]).toBe("/")
})

test("list(req, res, next)", () => {
  const mockCommodityList = ["foo", "bar"]
  mockRepo.commodity.selectAll.mockReturnValue(mockCommodityList)

  const routes = new CommodityRoutes(mockRouter, mockRepo)
  routes.list(mockRequest, mockResponse, null)

  expect(mockRepo.commodity.selectAll).toHaveBeenCalled()
  expect(mockResponse.json).toHaveBeenCalledWith(mockCommodityList)
})

test("create(req, res, next)", async () => {
  mockRepo.commodity.insert.mockReturnValue(mockCommodityNew)

  const commodityRoutes = new CommodityRoutes(mockRouter, mockRepo)
  commodityRoutes.create(mockRequest, mockResponse, null)

  expect(mockRepo.commodity.insert).toHaveBeenCalledWith(mockCommodityOrig)
  expect(mockResponse.json).toHaveBeenCalledWith(mockCommodityNew)
})

test("update(req, res, next)", async () => {
  const mockReq2 = { ...mockRequest }
  mockReq2.fields.id = mockCommodityId
  mockReq2.fields.version = "mock version 1"
  const mockCommodityOrig2 = {
    ...mockCommodityOrig, ...{
      id: mockReq2.fields.id,
      version: mockReq2.fields.version
    }
  }
  mockRepo.commodity.update.mockReturnValue(mockCommodityNew)

  const commodityRoutes = new CommodityRoutes(mockRouter, mockRepo)
  commodityRoutes.update(mockReq2, mockResponse, null)

  expect(mockRepo.commodity.update).toHaveBeenCalledWith(mockCommodityOrig2)
  expect(mockResponse.json).toHaveBeenCalledWith(mockCommodityNew)
})

// test("delete(req, res, next)", async () => {
//   const mockReq2 = { ...mockRequest }
//   mockReq2.fields.accountId = mockAccountId
//   mockReq2.fields.md5 = "original Md5"
//   const mockAccountOrig2 = {
//     ...mockAccountOrig, ...{
//       accountId: mockAccountId,
//       md5: mockReq2.fields.md5
//     }
//   }
//   const mockResp2 = {
//     json: jest.fn(),
//     status: jest.fn()
//   }
//   mockResp2.status.mockReturnValue(mockResp2)

//   const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
//   await accountRoutes.delete(mockReq2, mockResp2, null)

//   expect(mockRepo.account.delete).toHaveBeenCalledWith(mockAccountOrig2)
//   expect(mockResp2.status).toHaveBeenCalledWith(200)
//   expect(mockResp2.json).toHaveBeenCalledWith({})
// })