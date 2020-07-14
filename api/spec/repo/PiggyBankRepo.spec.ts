import "jasmine";
import { PiggyBankRepo } from "../../src/repo/PiggyBankRepo";

describe("PiggyBankRepo", () => {
  it("should require instances of (pg.Pool, fs, path) to construct", () => {
    const pool = jasmine.createSpyObj("pg.Pool", ["connect"], ["database", "user", "password"]);
    const readdir = jasmine.createSpy("readdir");
    const readfile = jasmine.createSpy("readfile");
    const path = jasmine.createSpyObj("path", ["join"]);
    const repo = new PiggyBankRepo(pool, readdir, readfile, path);
    expect(repo.pool).toBe(pool);
  });
});