const { PiggyBankApi } = require("../server")

const app = {
  use: jest.fn(),
  listen: jest.fn()
}
const express = jest.fn().mockReturnValue(app)
express.Router = jest.fn().mockReturnValue({
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  delete: jest.fn(),
})
express.static = jest.fn()

const repo = {
  updateDb: jest.fn()
}

test("register formidable as a request handler", () => {
  const server = new PiggyBankApi(repo, 3030)
  server.start()
  expect(app.use).toHaveBeenCalledWith(formHandler)
})

test("use port set by constructor", () => {
  const server = new PiggyBankApi(repo, 3030)
  server.start()
  expect(app.listen).toHaveBeenCalledTimes(1)
  expect(app.listen.mock.calls[0][0]).toBe(3030)
})

test("update the Repository when the server starts", () => {
  const server = new PiggyBankApi(repo, 3030)
  erver.start()
  expect(repo.updateDb).toHaveBeenCalledTimes(1)
})

test("skipIndex returns true when path starts with /api", () => {
  const server = new PiggyBankApi(repo, 3030)
  const skipIndex = server.skipIndex({ url: "/api/foo/bar" })
  expect(skipIndex).toBe(true)
})

test("skipIndex returns true when path does not start with /api", () => {
  const server = new PiggyBankApi(repo, 3030)
  const skipIndex = server.skipIndex({ url: "/foo/bar" })
  expect(skipIndex).toBe(false)
})

test("sendIndex calls next() when path starts with /api", () => {
  const server = new PiggyBankApi(repo, 3030)
  const res = jest.fn()
  const next = jest.fn()
  server.sendIndex({ url: "/api/foo/bar" }, res, next)
  expect(next).toHaveBeenCalledTimes(1);
})

test("sendIndex sends index when path does not start with /api", () => {
  const indexPath = "/PiggyBank/www/index.html"
  jest.mock("path.join").mockReturnValue(indexPath)
  const server = new PiggyBankApi(repo, 3030)
  const res = { sendFile: jest.fn() }
  const next = jest.fn()
  server.sendIndex({ url: "/foo/bar" }, res, next)
  expect(res.sendFile).toHaveBeenCalledWith(indexPath)
})

test("app uses ${__dirname}/../www to serve static files", () => {
  const e_static = "express.static() does not return a string"
  express.static = jest.fn().mockReturnValue(e_static)
  const mockStaticDir = "/PiggyBank/www"
  jest.mock("path").mockReturnValue({
    join: jest.fn().mockReturnValue(mockStaticDir)
  })
  const server = new PiggyBankApi(repo, 3030)

  expect(pathJoin).toHaveBeenCalledWith(__dirname.replace("/__tests__", ""), "..", "www")
  expect(express.static).toHaveBeenCalledWith(mockStaticDir)
  expect(app.use).toHaveBeenCalledWith(e_static)
})

test("app uses sendIndex", () => {
  const server = new PiggyBankApi(repo, 3030)
  let boundSendIndexUsed = false
  app.use.mock.calls.forEach((v, i, a) => {
    if (v[0]) {
      if (v[0].name === "bound sendIndex") {
        boundSendIndexUsed = true
      }
    }
  })
  expect(boundSendIndexUsed).toBe(true)
})

test("AccountRoutes assigned to /api/account", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(app.use).toHaveBeenCalledWith("/api/account", express.Router())
})

test("ApiKeyRoutes assigned to /api/apikey", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(app.use).toHaveBeenCalledWith("/api/apikey", express.Router())
})

test("CommodityRoutes assigned to /api/commodity", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(app.use).toHaveBeenCalledWith("/api/commodity", express.Router())
})

test("OfxRoutes assigned to /api/ofx", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(app.use).toHaveBeenCalledWith("/api/ofx", express.Router())
})

test("PriceRoutes assigned to /api/price", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(app.use).toHaveBeenCalledWith("/api/price", express.Router())
})

test("TxRoutes assigned to /api/tx", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(app.use).toHaveBeenCalledWith("/api/tx", express.Router())
})
