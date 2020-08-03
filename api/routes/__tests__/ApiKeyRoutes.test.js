const { ApiKeyRoutes } = require("../ApiKeyRoutes")
const helpers = require("../../__tests__/testHelpers.js")

const mockRouter = helpers.mockRouter()
const mockRepo = helpers.mockRepo()
const mockRequest = helpers.mockRequest()
const mockResponse = helpers.mockResponse()

test("new ApiKeyRoutes(router, repo)", () => {
  const routes = new ApiKeyRoutes(mockRouter, mockRepo)
  expect(routes.repo).toBe(mockRepo)
})

test("sets up routes", () => {
  const routes = new ApiKeyRoutes(mockRouter, mockRepo)
  expect(mockRouter.get.mock.calls[0][0]).toBe("/")
  // expect(mockRouter.post.mock.calls[0][0]).toBe("/")
  // expect(mockRouter.put.mock.calls[0][0]).toBe("/:id")
  // expect(mockRouter.delete.mock.calls[0][0]).toBe("/")
})

test("list(req, res, next)", () => {
  const mockResults = ["foo", "bar"]
  mockRepo.apiKey.selectAll.mockReturnValue(mockResults)

  const routes = new ApiKeyRoutes(mockRouter, mockRepo)
  routes.list(mockRequest, mockResponse, null)

  expect(mockRepo.apiKey.selectAll).toHaveBeenCalled()
  expect(mockResponse.json).toHaveBeenCalledWith(mockResults)
})

// test("create(req, res, next)", async () => {
//   mockRepo.account.insert.mockResolvedValue(mockAccountNew)

//   const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
//   await accountRoutes.create(mockRequest, mockResponse, null)

//   expect(mockRepo.account.insert).toHaveBeenCalledWith(mockAccountOrig)
//   expect(mockResponse.json).toHaveBeenCalledWith(mockAccountNew)
// })

// test("update(req, res, next)", async () => {
//   const mockReq2 = { ...mockRequest }
//   mockReq2.fields.accountId = mockAccountId
//   mockReq2.fields.md5 = "original Md5"
//   const mockAccountOrig2 = {
//     ...mockAccountOrig, ...{
//       accountId: mockAccountId,
//       md5: mockReq2.fields.md5
//     }
//   }
//   mockRepo.account.update.mockResolvedValue(mockAccountNew)

//   const accountRoutes = new AccountRoutes(mockRouter, mockRepo)
//   await accountRoutes.update(mockReq2, mockResponse, null)

//   expect(mockRepo.account.update).toHaveBeenCalledWith(mockAccountOrig2)
//   expect(mockResponse.json).toHaveBeenCalledWith(mockAccountNew)
// })

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