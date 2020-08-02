const mockApp = {
  use: jest.fn(),
  listen: jest.fn()
}

jest.mock("express", () => {
  return () => {
    return mockApp
  }
})

const mockFormidable = {
  IncomingForm: jest.fn(),
  name: "formidable"
}

jest.mock("express-formidable", () => {
  return () => mockFormidable
})

jest.mock("better-sqlite3", () => { })

jest.mock("../repo/PiggyBankRepo.js")

const mockPath = {
  join: jest.fn()
}
jest.mock("path", () => mockPath)

const express = require("express")
const formidable = require("express-formidable")
const path = require("path")
const { PiggyBankApi } = require("../server")
const { PiggyBankRepo } = require("../repo/PiggyBankRepo.js")

const mockRouter = {
  get: jest.fn(),
  put: jest.fn(),
  post: jest.fn(),
  delete: jest.fn()
}

let repo
beforeEach(() => {
  express.static = jest.fn()
  express.Router = jest.fn().mockImplementation(() => mockRouter)
  repo = new PiggyBankRepo()
})

test("register formidable as a request handler", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(mockApp.use).toHaveBeenCalledWith(mockFormidable)
})

test("use port set by constructor", () => {
  const server = new PiggyBankApi(repo, 3030)
  server.start()
  expect(mockApp.listen).toHaveBeenCalledTimes(1)
  expect(mockApp.listen.mock.calls[0][0]).toBe(3030)
})

test("update the Repository when the server starts", () => {
  const server = new PiggyBankApi(repo, 3030)
  server.start()
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
  const mockPath = "/PiggyBank/www/index.html"
  path.join.mockReturnValue(mockPath)

  const server = new PiggyBankApi(repo, 3030)
  const res = { sendFile: jest.fn() }
  const next = jest.fn()
  server.sendIndex({ url: "/foo/bar" }, res, next)
  expect(res.sendFile).toHaveBeenCalledWith(mockPath)
})

test("app uses ${__dirname}/../www to serve static files", () => {
  const mockPath = "/PiggyBank/www"
  path.join.mockReturnValue(mockPath)

  const e_static = "express.static() does not return a string"
  express.static = jest.fn().mockReturnValue(e_static)

  const server = new PiggyBankApi(repo, 3030)

  expect(path.join).toHaveBeenCalledWith(__dirname.replace("/__tests__", ""), "..", "www")
  expect(express.static).toHaveBeenCalledWith(mockPath)
  expect(mockApp.use).toHaveBeenCalledWith(e_static)
})

test("app uses sendIndex", () => {
  const server = new PiggyBankApi(repo, 3030)
  let boundSendIndexUsed = false
  mockApp.use.mock.calls.forEach((v, i, a) => {
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
  expect(mockApp.use).toHaveBeenCalledWith("/api/account", mockRouter)
})

test("ApiKeyRoutes assigned to /api/apikey", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(mockApp.use).toHaveBeenCalledWith("/api/apikey", mockRouter)
})

test("CommodityRoutes assigned to /api/commodity", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(mockApp.use).toHaveBeenCalledWith("/api/commodity", mockRouter)
})

test("OfxRoutes assigned to /api/ofx", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(mockApp.use).toHaveBeenCalledWith("/api/ofx", mockRouter)
})

test("PriceRoutes assigned to /api/price", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(mockApp.use).toHaveBeenCalledWith("/api/price", mockRouter)
})

test("TxRoutes assigned to /api/tx", () => {
  const server = new PiggyBankApi(repo, 3030)
  expect(mockApp.use).toHaveBeenCalledWith("/api/tx", mockRouter)
})
