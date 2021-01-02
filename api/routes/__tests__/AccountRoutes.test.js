const { AccountRoutes } = require("../AccountRoutes")
const helpers = require("../../__tests__/testHelpers.js")

const mockRouter = helpers.mockRouter()
const mockRepo = helpers.mockRepo()

const mockRequest = helpers.mockRequest()
mockRequest.fields.name = "mock account"
mockRequest.fields.isPlaceholder = true
mockRequest.fields.parentId = 123
mockRequest.fields.currencyId = 345
const mockResponse = helpers.mockResponse()

const mockAccountOrig = {
  isPlaceholder: mockRequest.fields.isPlaceholder,
  name: mockRequest.fields.name,
  parentId: mockRequest.fields.parentId,
  currencyId: mockRequest.fields.currencyId
}
const mockAccountId = 890
const mockAccountVersion = "mock version"
const mockAccountNew = Object.assign({
  id: mockAccountId,
  version: mockAccountVersion
}, mockAccountOrig)

test("new AccountRoutes(router, repo)", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
  expect(accountRoutes.repo).toBe(mockRepo)
})

test("sets up routes", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo)

  expect(mockRouter.get.mock.calls[0][0]).toBe("/")
  expect(mockRouter.post.mock.calls[0][0]).toBe("/")
  expect(mockRouter.put.mock.calls[0][0]).toBe("/:id")
  expect(mockRouter.delete.mock.calls[0][0]).toBe("/")
})

test("list(req, res, next)", () => {
  const mockAccountList = [{ id: 1, name: "mock account" }]
  mockRepo.account.selectAll.mockReturnValue(mockAccountList)

  const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
  accountRoutes.list(mockRequest, mockResponse, null)

  expect(mockRepo.account.selectAll).toHaveBeenCalled()
  expect(mockResponse.json).toHaveBeenCalledWith(mockAccountList)
})

test("create(req, res, next)", () => {
  mockRepo.account.insert.mockReturnValue(mockAccountNew)

  const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
  accountRoutes.create(mockRequest, mockResponse, null)

  expect(mockRepo.account.insert).toHaveBeenCalledWith(mockAccountOrig)
  expect(mockResponse.json).toHaveBeenCalledWith(mockAccountNew)
})

test("update(req, res, next)", () => {
  const mockReq2 = { ...mockRequest }
  mockReq2.fields.id = mockAccountId
  mockReq2.fields.version = "original version"
  const mockAccountOrig2 = {
    ...mockAccountOrig, ...{
      id: mockAccountId,
      version: mockReq2.fields.version
    }
  }
  mockRepo.account.update.mockReturnValue(mockAccountNew)

  const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
  accountRoutes.update(mockReq2, mockResponse, null)

  expect(mockRepo.account.update).toHaveBeenCalledWith(mockAccountOrig2)
  expect(mockResponse.json).toHaveBeenCalledWith(mockAccountNew)
})

test("delete(req, res, next)", () => {
  const mockReq2 = { ...mockRequest }
  mockReq2.fields.id = mockAccountId
  mockReq2.fields.version = "original version"
  const mockAccountOrig2 = {
    ...mockAccountOrig, ...{
      id: mockAccountId,
      version: mockReq2.fields.version
    }
  }
  const mockResp2 = {
    json: jest.fn(),
    status: jest.fn()
  }
  mockResp2.status.mockReturnValue(mockResp2)

  const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
  accountRoutes.delete(mockReq2, mockResp2, null)

  expect(mockRepo.account.delete).toHaveBeenCalledWith(mockAccountOrig2)
  expect(mockResp2.status).toHaveBeenCalledWith(200)
  expect(mockResp2.json).toHaveBeenCalledWith({})
})