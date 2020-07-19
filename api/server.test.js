const formidable = require("express-formidable");
const PiggyBankApi = require("./server");

const app = {
  use: jest.fn(),
  listen: jest.fn()
};
const express = jest.fn().mockReturnValue(app);

express.Router = jest.fn().mockReturnValue({
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  delete: jest.fn(),
})

const repo = {
  updateDb: jest.fn()
};
const formHandler = formidable();

let server
beforeEach(() => {
  server = new PiggyBankApi(express, repo, formHandler, 3030);
})

test("register formidable as a request handler", async () => {
  await server.start();
  expect(app.use).toHaveBeenCalledWith(formHandler);
});

test("use port set by constructor", async () => {
  await server.start();
  expect(app.listen).toHaveBeenCalledTimes(1);
  expect(app.listen.mock.calls[0][0]).toBe(3030);
});

test("update the Repository when the server starts", async () => {
  await server.start();
  expect(repo.updateDb).toHaveBeenCalledTimes(1);
});

test("AccountRoutes assigned to /api/account", async () => {
  await server.start();
  expect(app.use).toHaveBeenCalledWith("/api/account", express.Router())
})
