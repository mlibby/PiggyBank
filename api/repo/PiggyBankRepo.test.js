const PiggyBankRepo = require("./PiggyBankRepo");

const mockResults = {
  rows: ["test"]
};
const client = {
  query: jest.fn().mockReturnValue(mockResults),
  release: jest.fn()
};
const pool = {
  connect: jest.fn().mockReturnValue(client)
};
const migrationDir = "migrations";
const migration00001 = "00001_migration.sql";
const migration00002 = "00002_account.sql";
const migration00003 = "00003_tx.sql";
const migration00004 = "00004_budget.sql";
const path00001 = "migrations/00001_migration.sql";
const path00002 = "migrations/00002_account.sql";
const path00003 = "migrations/00003_tx.sql";
const path00004 = "migrations/00004_budget.sql";
const sql00001 = "select * from migrations";
const sql00002 = "select * from accounts";
const sql00003 = "select * from tx";
const sql00004 = "select * from budget";

let readdir;
let readfile;
let pathJoin;

beforeEach(() => {
  pathJoin = jest.fn();
  pathJoin.mockReturnValueOnce(migrationDir)
    .mockReturnValueOnce(path00001)
    .mockReturnValueOnce(path00002)
    .mockReturnValueOnce(path00003)
    .mockReturnValueOnce(path00004);

  readdir = jest.fn();
  readdir.mockReturnValueOnce([
    migration00001,
    migration00002,
    migration00003,
    migration00004
  ]);

  readfile = jest.fn();
  readfile.mockReturnValueOnce(sql00001)
    .mockReturnValueOnce(sql00002)
    .mockReturnValueOnce(sql00003)
    .mockReturnValueOnce(sql00004);
});

test("new PiggyBankRepo() requires instances of (pg.Pool, readdir, readfile, path.join)", () => {
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  expect(repo.pool).toBe(pool);
  expect(repo.readdir).toBe(readdir);
  expect(repo.readfile).toBe(readfile);
  expect(repo.pathJoin).toBe(pathJoin);
});

test("connect to pg.Pool and collect results for query(sql, values)", async () => {
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  const sql = 'select * from table';
  const values = ["foo", "bar"];
  const results = await repo.query(sql, values);
  expect(pool.connect).toHaveBeenCalledTimes(1);
  expect(client.query).toHaveBeenCalledWith(sql, values);
  expect(results).toBe(mockResults);
});

test("getCurrentLevel() returns 0 when no migrations have run yet", async () => {
  client.query = jest.fn().mockImplementation(() => {
    throw new Error('relation "migration" does not exist');
  });

  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  const level = await repo.getMigrationLevel();
  expect(client.query).toHaveBeenCalledWith('select max(level) from migration', undefined);
  expect(level).toBe(0);
});

test("getCurrentLevel() > 0 once migrations have been run", async () => {
  client.query = jest.fn().mockResolvedValue({ rows: [{ max: "1" }] });
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  const level = await repo.getMigrationLevel();
  expect(client.query).toHaveBeenCalledWith('select max(level) from migration', undefined);
  expect(level).toBe(1);
});

test("getCurrentLevel() only swallows 'migrations' missing error", async () => {
  client.query = jest.fn().mockImplementation(() => {
    throw new Error("this is not a migrations error");
  });
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  expect(async () => {
    const level = await repo.getMigrationLevel();
  }).rejects.toThrow();
});

test("updateDb() gets migration directory", async () => {
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  repo.updateDb();
  expect(pathJoin).toHaveBeenCalled();
  expect(pathJoin).toHaveBeenCalledWith(__dirname, "../migrations");
});

test("updateDb() gets the current migration level", async () => {
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  repo.getMigrationLevel = jest.fn();
  repo.updateDb();
  expect(repo.getMigrationLevel).toHaveBeenCalledTimes(1);
});

test("updateDb() gets the file list from migrations dir", async () => {
  pathJoin.mockReturnValue(migrationDir);

  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  repo.updateDb();

  expect(readdir).toHaveBeenCalledTimes(1);
  expect(readdir).toHaveBeenCalledWith(migrationDir);
});

test("updateDb() runs all migrations at migration level 0", () => {
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  repo.query = jest.fn();
  repo.getMigrationLevel = jest.fn().mockResolvedValueOnce(0);
  repo.updateDb();

  expect(pathJoin).toHaveBeenCalledTimes(5);
  expect(pathJoin.mock.calls[1]).toEqual([migrationDir, migration00001]);
  expect(pathJoin.mock.calls[2]).toEqual([migrationDir, migration00002]);
  expect(pathJoin.mock.calls[3]).toEqual([migrationDir, migration00003]);
  expect(pathJoin.mock.calls[4]).toEqual([migrationDir, migration00004]);

  expect(readfile).toHaveBeenCalledTimes(4);
  expect(readfile.mock.calls[0]).toEqual([path00001]);
  expect(readfile.mock.calls[1]).toEqual([path00002]);
  expect(readfile.mock.calls[2]).toEqual([path00003]);
  expect(readfile.mock.calls[3]).toEqual([path00004]);

  // would expect 5 queries, but we're mocking getMigrationLevel()
  expect(repo.query).toHaveBeenCalledTimes(4);
  expect(repo.query.mock.calls[0]).toEqual([sql00001]);
  expect(repo.query.mock.calls[1]).toEqual([sql00002]);
  expect(repo.query.mock.calls[2]).toEqual([sql00003]);
  expect(repo.query.mock.calls[3]).toEqual([sql00004]);
});

test("updateDb() runs only pending migrations at level 2", () => {
  pathJoin = jest.fn();
  pathJoin.mockReturnValueOnce(migrationDir)
    .mockReturnValueOnce(path00003)
    .mockReturnValueOnce(path00004);

  readfile = jest.fn();
  readfile.mockReturnValueOnce(sql00003)
    .mockReturnValueOnce(sql00004);

  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  repo.query = jest.fn();
  repo.getMigrationLevel = jest.fn().mockResolvedValueOnce(2);
  repo.updateDb();

  expect(pathJoin).toHaveBeenCalledTimes(3);

  expect(pathJoin.mock.calls[1]).toEqual([migrationDir, migration00003]);
  expect(pathJoin.mock.calls[2]).toEqual([migrationDir, migration00004]);

  expect(readfile).toHaveBeenCalledTimes(2);
  expect(readfile.mock.calls[0]).toEqual([path00003]);
  expect(readfile.mock.calls[1]).toEqual([path00004]);

  expect(repo.query).toHaveBeenCalledTimes(2);
  expect(repo.query.mock.calls[0]).toEqual([sql00003]);
  expect(repo.query.mock.calls[1]).toEqual([sql00004]);
});

test("repo.account is an AccountRepo", () => {
  const repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin);
  expect(repo.account.constructor.name).toBe("AccountRepo");
});