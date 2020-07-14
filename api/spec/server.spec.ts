import "jasmine";
import express from "express";
import { PiggyBankApi } from "../src/server";
import { PiggyBankRepo } from "../src/repo/PiggyBankRepo";

describe("PiggyBank API server", () => {
  let app: express.Application;
  let repo: PiggyBankRepo;
  let server: PiggyBankApi;

  beforeEach(() => {
    app = jasmine.createSpyObj("express.Application", ["listen"]);
    repo = jasmine.createSpyObj("PiggyBankRepo", ["updateDb"], ["pool"]);
    server = new PiggyBankApi(app, repo);
  })

  it("should start server on port 3030 by default", () => {
    server.start();
    expect(app.listen).toHaveBeenCalledTimes(1);
    expect(server.port).toBe(3030);
  });

  it("should update the Repository when the server starts", () => {
    server.start();
    expect(repo.updateDb).toHaveBeenCalledTimes(1);
  });
});