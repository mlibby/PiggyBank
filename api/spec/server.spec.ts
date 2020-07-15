import "jasmine";
import express from "express";
import { PiggyBankApi } from "../src/server";
import { PiggyBankRepo } from "../src/repo/PiggyBankRepo";

describe("PiggyBank API server startup", () => {
  let app: express.Application;
  let repo: PiggyBankRepo;
  let formHandler: express.RequestHandler;
  let server: PiggyBankApi;

  beforeEach(() => {
    app = jasmine.createSpyObj("express.Application", ["listen", "use"]);
    repo = jasmine.createSpyObj("PiggyBankRepo", ["updateDb"], ["pool"]);
    formHandler = jasmine.createSpyObj("formidable", ["_"]);
    server = new PiggyBankApi(app, repo, formHandler);
    server.start();
  })

  it("should register formidable as a request handler", () => {
    expect(app.use).toHaveBeenCalledWith(formHandler);
  });

  it("should start server on port 3030 by default", () => {
    expect(app.listen).toHaveBeenCalledTimes(1);
    expect(server.port).toBe(3030);
  });

  it("should update the Repository when the server starts", () => {
    expect(repo.updateDb).toHaveBeenCalledTimes(1);
  });

});