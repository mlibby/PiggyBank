const formidable = require("express-formidable");
const PiggyBankApi = require("./server");

describe("PiggyBank API server startup", () => {
  let app;
  let repo;
  let server;

  const formHandler = formidable(); 

  beforeEach( function() {
    app = jasmine.createSpyObj("express.Application", ["listen", "use"]);
    repo = jasmine.createSpyObj("PiggyBankRepo", ["updateDb"], ["pool"]);
    server = new PiggyBankApi(app, repo, formHandler);
    server.start();
  });

  it("should register formidable as a request handler", function() {
    expect(app.use).toHaveBeenCalledWith(formHandler);
  });

  it("should start server on port 3030 by default", function() {
    expect(app.listen).toHaveBeenCalledTimes(1);
    expect(server.port).toBe(3030);
  });

  it("should update the Repository when the server starts", function() {
    expect(repo.updateDb).toHaveBeenCalledTimes(1);
  });
});