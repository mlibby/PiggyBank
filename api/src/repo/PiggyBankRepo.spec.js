const pg = require("pg");
const PiggyBankRepo = require("./PiggyBankRepo");

describe("PiggyBankRepo", () => {
  let pool;
  let client;
  let readdir;
  let readfile;
  let pathJoin;
  let repo;

  beforeEach(() => {
    client = jasmine.createSpyObj("pg.Client", ["query", "release"]);
    pool = jasmine.createSpyObj("pg.Pool", ["connect"], ["database", "user", "password"]);
    readdir = jasmine.createSpy("readdir");
    readfile = jasmine.createSpy("readfile");
    pathJoin = jasmine.createSpy("pathJoin");
    repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  });

  it("should require instances of (pg.Pool, readdir, readfile, path.join) to construct", () => {
    expect(repo.pool).toBe(pool);
  });

  it("should connect to the pool and collect results for query(sql, values)", async () => {
    const mockResults = {rows: ["test"]};
    pool.connect.and.returnValue(client);
    client.query.and.returnValue(mockResults);

    const sql = 'select * from table';
    const values = [];
    const results = await repo.query(sql, values);
    expect(pool.connect).toHaveBeenCalledTimes(1);
    expect(client.query).toHaveBeenCalledWith(sql, values);
    expect(results).toBe(mockResults);
  });

  it("should return 0 when running getCurrentLevel() with no migrations", () => {

  });

  it("should handle missing 'migration' table when running migrations", () => {

  });
});
