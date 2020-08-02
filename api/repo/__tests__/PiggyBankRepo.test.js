const mockMigrationDir = "migrations"
const mockMigration00001 = "00001_migration.sql"
const mockMigration00002 = "00002_account.sql"
const mockMigration00003 = "00003_tx.sql"
const mockMigration00004 = "00004_budget.sql"
const mockPath00001 = "migrations/00001_migration.sql"
const mockPath00002 = "migrations/00002_account.sql"
const mockPath00003 = "migrations/00003_tx.sql"
const mockPath00004 = "migrations/00004_budget.sql"
const mockSql00001 = "select * from migrations"
const mockSql00002 = "select * from accounts"
const mockSql00003 = "select * from tx"
const mockSql00004 = "select * from budget"

jest.mock("fs", () => {
  return {
    readdirSync: jest.fn()
      .mockReturnValue([
        mockMigration00001,
        mockMigration00002,
        mockMigration00003,
        mockMigration00004
      ]),
    readfileSync: jest.fn()
      .mockReturnValueOnce(mockSql00001)
      .mockReturnValueOnce(mockSql00002)
      .mockReturnValueOnce(mockSql00003)
      .mockReturnValueOnce(mockSql00004)
  }
})

jest.mock("path", () => {
  return {
    join: jest.fn().mockReturnValueOnce(mockMigrationDir)
      .mockReturnValueOnce(mockPath00001)
      .mockReturnValueOnce(mockPath00002)
      .mockReturnValueOnce(mockPath00003)
      .mockReturnValueOnce(mockPath00004)
  }
})

class mockSQLite3 {
  constructor() { }
  pragma() { return this }
  prepare() { return this }
  get() { return this }
  pluck() { return this }
}

jest.mock("better-sqlite3", () => mockSQLite3)
const SQLite3 = require("better-sqlite3")
const db = new SQLite3()

const path = require("path")
const fs = require("fs")

const { PiggyBankRepo } = require("../PiggyBankRepo")

test("getCurrentLevel() returns 0 when no migrations have run yet", () => {
  db.prepare = jest.fn().mockReturnValue(db)
  
  db.get = jest.fn().mockImplementation(() => {
    throw new Error('Error: no such table: migrations')
  })

  const repo = new PiggyBankRepo()
  const level = repo.getMigrationLevel()
  expect(db.prepare).toHaveBeenCalledWith('select max(level) from migration')
  expect(level).toBe(0)
})

test("getCurrentLevel() > 0 once migrations have been run", () => {
  const repo = new PiggyBankRepo()
  const level = repo.getMigrationLevel()
  //expect(client.query).toHaveBeenCalledWith('select max(level) from migration', undefined)
  expect(level).toBe(1)
})

test("getCurrentLevel() only swallows 'migrations' missing error", () => {
  db.get = jest.fn().mockImplementation(() => {
    throw new Error("this is not a migrations error")
  })
  const repo = new PiggyBankRepo()
  expect(() => {
    const level = repo.getMigrationLevel()
  }).rejects.toThrow()
})

test("updateDb() gets migration directory", () => {
  const repo = new PiggyBankRepo()
  repo.updateDb()
  expect(path.join).toHaveBeenCalled()
  expect(path.join).toHaveBeenCalledWith(__dirname.replace("/__tests__", ""), "../migrations")
})

test("updateDb() gets the current migration level", () => {
  const repo = new PiggyBankRepo()
  repo.getMigrationLevel = jest.fn()
  repo.updateDb()
  expect(repo.getMigrationLevel).toHaveBeenCalledTimes(1)
})

test("updateDb() gets the file list from migrations dir", () => {
  path.join.mockReturnValue(mockMigrationDir)
  
  const repo = new PiggyBankRepo()
  repo.updateDb()

  expect(fs.readdirSync).toHaveBeenCalledTimes(1)
  expect(fs.readdirSync).toHaveBeenCalledWith(mockMigrationDir)
})

test("updateDb() runs all migrations at migration level 0", () => {
  const repo = new PiggyBankRepo()
  repo.query = jest.fn()
  repo.getMigrationLevel = jest.fn().mockResolvedValueOnce(0)
  repo.updateDb()

  expect(path.join).toHaveBeenCalledTimes(5)
  expect(path.join.mock.calls[1]).toEqual([mockMigrationDir, mockMigration00001])
  expect(path.join.mock.calls[2]).toEqual([mockMigrationDir, mockMigration00002])
  expect(path.join.mock.calls[3]).toEqual([mockMigrationDir, mockMigration00003])
  expect(path.join.mock.calls[4]).toEqual([mockMigrationDir, mockMigration00004])

  expect(readfile).toHaveBeenCalledTimes(4)
  expect(readfile.mock.calls[0]).toEqual([mockPath00001])
  expect(readfile.mock.calls[1]).toEqual([mockPath00002])
  expect(readfile.mock.calls[2]).toEqual([mockPath00003])
  expect(readfile.mock.calls[3]).toEqual([mockPath00004])

  // would expect 5 queries, but we're mocking getMigrationLevel()
  expect(repo.query).toHaveBeenCalledTimes(4)
  expect(repo.query.mock.calls[0]).toEqual([mockSql00001])
  expect(repo.query.mock.calls[1]).toEqual([mockSql00002])
  expect(repo.query.mock.calls[2]).toEqual([mockSql00003])
  expect(repo.query.mock.calls[3]).toEqual([mockSql00004])
})

test("updateDb() runs only pending migrations at level 2", () => {
  path.join = jest.fn()
    .mockReturnValueOnce(mockMigrationDir)
    .mockReturnValueOnce(mockPath00003)
    .mockReturnValueOnce(mockPath00004)

  fs.readfileSync = jest.fn()
    .mockReturnValueOnce(mockSql00003)
    .mockReturnValueOnce(mockSql00004)

  const repo = new PiggyBankRepo()
  repo.getMigrationLevel = jest.fn().mockResolvedValueOnce(2)
  repo.updateDb()

  expect(path.join).toHaveBeenCalledTimes(3)

  expect(path.join.mock.calls[1]).toEqual([mockMigrationDir, mockMigration00003])
  expect(path.join.mock.calls[2]).toEqual([mockMigrationDir, mockMigration00004])

  expect(fs.readfileSync).toHaveBeenCalledTimes(2)
  expect(fs.readfileSync.mock.calls[0]).toEqual([mockPath00003])
  expect(fs.readfileSync.mock.calls[1]).toEqual([mockPath00004])

  expect(repo.query).toHaveBeenCalledTimes(2)
  expect(repo.query.mock.calls[0]).toEqual([mockSql00003])
  expect(repo.query.mock.calls[1]).toEqual([mockSql00004])
})

test("repo.account is an AccountRepo", () => {
  const repo = new PiggyBankRepo()
  expect(repo.account.constructor.name).toBe("AccountRepo")
})

test("repo.apiKey is an ApiKeyRepo", () => {
  const repo = new PiggyBankRepo()
  expect(repo.apiKey.constructor.name).toBe("ApiKeyRepo")
})

test("repo.commodity is a CommodityRepo", () => {
  const repo = new PiggyBankRepo()
  expect(repo.commodity.constructor.name).toBe("CommodityRepo")
})

test("repo.ofx is a OfxRepo", () => {
  const repo = new PiggyBankRepo()
  expect(repo.ofx.constructor.name).toBe("OfxRepo")
})

test("repo.price is a PriceRepo", () => {
  const repo = new PiggyBankRepo()
  expect(repo.price.constructor.name).toBe("PriceRepo")
})

test("repo.tx is a TxRepo", () => {
  const repo = new PiggyBankRepo()
  expect(repo.tx.constructor.name).toBe("TxRepo")
})