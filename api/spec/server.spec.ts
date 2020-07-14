import "jasmine";
import "../src/server";
import { PiggyBankApi } from "../src/server";

describe("PiggyBank API server", () => {
  it("should pass", () => {
    let server = new PiggyBankApi();
    expect(server).toBeTruthy();
  });
});