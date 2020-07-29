const formidable = require("express-formidable")
const PiggyBankApi = require("../server")

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

const formHandler = formidable()
const pathJoin = jest.fn()

test("register formidable as a request handler", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  await server.start()
  expect(app.use).toHaveBeenCalledWith(formHandler)
})

test("use port set by constructor", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  await server.start()
  expect(app.listen).toHaveBeenCalledTimes(1)
  expect(app.listen.mock.calls[0][0]).toBe(3030)
})

test("update the Repository when the server starts", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  await server.start()
  expect(repo.updateDb).toHaveBeenCalledTimes(1)
})

test("skipIndex returns true when path starts with /api", () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  const skipIndex = server.skipIndex({ url: "/api/foo/bar" })
  expect(skipIndex).toBe(true)
})

test("skipIndex returns true when path does not start with /api", () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  const skipIndex = server.skipIndex({ url: "/foo/bar" })
  expect(skipIndex).toBe(false)
})

test("sendIndex calls next() when path starts with /api", () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  const res = jest.fn()
  const next = jest.fn()
  server.sendIndex({ url: "/api/foo/bar" }, res, next)
  expect(next).toHaveBeenCalledTimes(1);
})

test("sendIndex sends index when path does not start with /api", () => {
  const indexPath = "/PiggyBank/www/index.html"
  pathJoin.mockReturnValue(indexPath)
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  const res = { sendFile: jest.fn() }
  const next = jest.fn()
  server.sendIndex({ url: "/foo/bar" }, res, next)
  expect(res.sendFile).toHaveBeenCalledWith(indexPath)
})

test("app uses ${__dirname}/../www to serve static files", async () => {
  const e_static = "express.static() does not return a string"
  express.static = jest.fn().mockReturnValue(e_static)
  const mockStaticDir = "/PiggyBank/www"
  pathJoin.mockReturnValue(mockStaticDir)

  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)

  expect(pathJoin).toHaveBeenCalledWith(__dirname.replace("/__tests__", ""), "..", "www")
  expect(express.static).toHaveBeenCalledWith(mockStaticDir)
  expect(app.use).toHaveBeenCalledWith(e_static)
})

test("app uses sendIndex", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  expect(app.use).toHaveBeenCalledWith(server.sendIndex)
})

test("AccountRoutes assigned to /api/account", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  expect(app.use).toHaveBeenCalledWith("/api/account", express.Router())
})

test("ApiKeyRoutes assigned to /api/apikey", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  expect(app.use).toHaveBeenCalledWith("/api/apikey", express.Router())
})

test("CommodityRoutes assigned to /api/commodity", async () => {
  const server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
  expect(app.use).toHaveBeenCalledWith("/api/commodity", express.Router())
})
