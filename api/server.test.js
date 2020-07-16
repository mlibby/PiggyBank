const formidable = require("express-formidable");
const PiggyBankApi = require("./server");

const app = {
  use: jest.fn(),
  listen: jest.fn()
};
const repo = {
  updateDb: jest.fn()
};
const formHandler = formidable();

let server;

beforeEach(() => {
  server = new PiggyBankApi(app, repo, formHandler, 3030);
  server.start();
});

test("register formidable as a request handler", () => {
  expect(app.use).toHaveBeenCalledWith(formHandler);
});

test("use port set by constructor", () => {
  expect(app.listen).toHaveBeenCalledTimes(1);
  expect(server.port).toBe(3030);
});

test("update the Repository when the server starts", () => {
  expect(repo.updateDb).toHaveBeenCalledTimes(1);
});
