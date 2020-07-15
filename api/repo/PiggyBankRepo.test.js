const PiggyBankRepo = require("./PiggyBankRepo")

const mockResults = {
  rows: ["test"]
}
const client = {
  query: jest.fn().mockReturnValue(mockResults),
  release: jest.fn()
}
const pool = {
  connect: jest.fn().mockReturnValue(client)
}
const readdir = jest.fn()
const readfile = jest.fn()
const pathJoin = jest.fn()

let repo

test("new PiggyBankRepo() requires instances of (pg.Pool, readdir, readfile, path.join)", () => {
  repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin)
  expect(repo.pool).toBe(pool)
  expect(repo.readdir).toBe(readdir)
  expect(repo.readfile).toBe(readfile)
  expect(repo.pathJoin).toBe(pathJoin)
})

test("connect to pg.Pool and collect results for query(sql, values)", async () => {
  repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin)
  const sql = 'select * from table'
  const values = ["foo", "bar"]
  const results = await repo.query(sql, values)
  expect(pool.connect).toHaveBeenCalledTimes(1)
  expect(client.query).toHaveBeenCalledWith(sql, values)
  expect(results).toBe(mockResults)
})

test("getCurrentLevel() returns 0 when no migrations have run yet", async () => {
  client.query = jest.fn().mockImplementation(() => {
    throw new Error('relation "migration" does not exist')
  })

  repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin)
  const level = await repo.getMigrationLevel()
  expect(client.query).toHaveBeenCalledWith('select max(level) from migration', undefined)
  expect(level).toBe(0)
})

test("getCurrentLevel() > 0 once migrations have been run", async () => {
  client.query = jest.fn().mockReturnValue({ rows: [{ max: "1" }] })
  repo = new PiggyBankRepo(pool, readdir, readfile, pathJoin)
  const level = await repo.getMigrationLevel()
  expect(client.query).toHaveBeenCalledWith('select max(level) from migration', undefined)
  expect(level).toBe(1)
})