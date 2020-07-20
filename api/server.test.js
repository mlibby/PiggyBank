const formidable = require("express-formidable")
const PiggyBankApi = require("./server")

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

let server
beforeEach(() => {
  server = new PiggyBankApi(express, repo, formHandler, 3030, pathJoin)
})

test("register formidable as a request handler", async () => {
  await server.start()
  expect(app.use).toHaveBeenCalledWith(formHandler)
})

test("use port set by constructor", async () => {
  await server.start()
  expect(app.listen).toHaveBeenCalledTimes(1)
  expect(app.listen.mock.calls[0][0]).toBe(3030)
})

test("app uses ${__dirname}/../www to serve static files", async () => {
  const e_static = "express.static() does not return a string"
  express.static = jest.fn().mockReturnValue(e_static)
  const mockStaticDir = "/PiggyBank/www"
  pathJoin.mockReturnValue(mockStaticDir)

  await server.start()
  
  expect(pathJoin).toHaveBeenCalledWith(__dirname, "..", "www")
  expect(express.static).toHaveBeenCalledWith(mockStaticDir)
  expect(app.use).toHaveBeenCalledWith(e_static)
})

test("update the Repository when the server starts", async () => {
  await server.start()
  expect(repo.updateDb).toHaveBeenCalledTimes(1)
})

test("AccountRoutes assigned to /api/account", async () => {
  await server.start()
  expect(app.use).toHaveBeenCalledWith("/api/account", express.Router())
})
