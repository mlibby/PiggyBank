const AccountRoutes = require("./AccountRoutes");
const helpers = require("../testHelpers.js");

const bindVal = "call with 'this'";
const mockRouter = helpers.mockRouter();
const mockRepo = helpers.mockRepo();
const mockRequest = helpers.mockRequest();
const mockResult = helpers.mockResult();

test("new AccountRoutes(router, repo)", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo);
  expect(accountRoutes.repo).toBe(mockRepo);
});

test("sets up routes", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo);
  accountRoutes.list = {bind: jest.fn().mockReturnValue(bindVal)};

  expect(mockRouter.get.mock.calls[0][0]).toBe("/");
  expect(mockRouter.post.mock.calls[0][0]).toBe("/");
  expect(mockRouter.put.mock.calls[0][0]).toBe("/:id");
  expect(mockRouter.delete.mock.calls[0][0]).toBe("/");
});

test("list(req, res, next)", async () => {
  const mockAccountList = [{accountId: 1, name: "mock account"}];
  mockRepo.account.selectAll.mockResolvedValue(mockAccountList);

  const accountRoutes = new AccountRoutes(mockRouter, mockRepo);
  await accountRoutes.list(mockRequest, mockResult, null);

  expect(mockRepo.account.selectAll).toHaveBeenCalled();
  expect(mockResult.json).toHaveBeenCalledWith(mockAccountList);
});

test("create(req, res, next)", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo);
  accountRoutes.create(mockRequest, mockResult, null);
});

test("update(req, res, next)", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo);
  accountRoutes.update(mockRequest, mockResult, null);
});

test("delete(req, res, next)", () => {
  const accountRoutes = new AccountRoutes(mockRouter, mockRepo);
  accountRoutes.delete(mockRequest, mockResult, null);
});