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
    readdirSync: jest.fn(),
    readFileSync: jest.fn()
  }
})

jest.mock("path", () => {
  return {
    join: jest.fn()
  }
})

const { MockSQLite3 } = require("../__mocks__/SQLite3.mock.js")
jest.mock("better-sqlite3", () => MockSQLite3)
const SQLite3 = require("better-sqlite3")

const path = require("path")
const fs = require("fs")

const { PiggyBankRepo } = require("../PiggyBankRepo")

let repo
beforeEach(() => {
  repo = new PiggyBankRepo()

  fs.readdirSync = jest.fn()
    .mockReturnValue([
      mockMigration00001,
      mockMigration00002,
      mockMigration00003,
      mockMigration00004
    ])

  fs.readFileSync = jest.fn()
    .mockReturnValueOnce(mockSql00001)
    .mockReturnValueOnce(mockSql00002)
    .mockReturnValueOnce(mockSql00003)
    .mockReturnValueOnce(mockSql00004)

  path.join = jest.fn()
    .mockReturnValueOnce(mockMigrationDir)
    .mockReturnValueOnce(mockPath00001)
    .mockReturnValueOnce(mockPath00002)
    .mockReturnValueOnce(mockPath00003)
    .mockReturnValueOnce(mockPath00004)
})

test("getVersion returns a timestamp in ISO format", () => {
  const version = repo.getVersion()
  expect(version).toEqual(expect.stringMatching(/^\d\d\d\d\-\d\d-\d\dT\d\d\:\d\d\:\d\d\.\d\d\dZ$/))
})

test("getCurrentLevel() returns 0 when no migrations have run yet", () => {
  repo.db.get = jest.fn().mockImplementation(() => {
    throw new Error('no such table: migration')
  })

  const level = repo.getMigrationLevel()
  expect(repo.db.prepare).toHaveBeenCalledWith('select max(level) from migration')
  expect(level).toBe(0)
})

test("getCurrentLevel() > 0 once migrations have been run", () => {
  repo.db.get.mockReturnValue(1)
  const level = repo.getMigrationLevel()
  expect(repo.db.prepare).toHaveBeenCalledWith('select max(level) from migration')
  expect(repo.db.pluck).toHaveBeenCalled()
  expect(repo.db.get).toHaveBeenCalled()
  expect(level).toBe(1)
})

test("getCurrentLevel() only swallows 'migrations' missing error", () => {
  repo.db.get = jest.fn().mockImplementation(() => {
    throw new Error("this is not a migrations error")
  })
  expect(() => {
    const level = repo.getMigrationLevel()
  }).toThrow()
})

test("updateDb() gets migration directory", () => {
  repo.updateDb()
  expect(path.join).toHaveBeenCalled()
  expect(path.join).toHaveBeenCalledWith(__dirname.replace("/__tests__", ""), "../migrations")
})

test("updateDb() gets the current migration level", () => {
  repo.getMigrationLevel = jest.fn()
  repo.updateDb()
  expect(repo.getMigrationLevel).toHaveBeenCalledTimes(1)
})

test("updateDb() gets the file list from migrations dir", () => {
  path.join.mockReturnValue(mockMigrationDir)

  repo.updateDb()

  expect(fs.readdirSync).toHaveBeenCalledTimes(1)
  expect(fs.readdirSync).toHaveBeenCalledWith(mockMigrationDir)
})

test("updateDb() runs all migrations at migration level 0", () => {
  repo.query = jest.fn()
  repo.getMigrationLevel = jest.fn().mockReturnValue(0)
  repo.updateDb()

  expect(path.join).toHaveBeenCalledTimes(5)
  expect(path.join.mock.calls[1]).toEqual([mockMigrationDir, mockMigration00001])
  expect(path.join.mock.calls[2]).toEqual([mockMigrationDir, mockMigration00002])
  expect(path.join.mock.calls[3]).toEqual([mockMigrationDir, mockMigration00003])
  expect(path.join.mock.calls[4]).toEqual([mockMigrationDir, mockMigration00004])

  expect(fs.readFileSync).toHaveBeenCalledTimes(4)
  expect(fs.readFileSync.mock.calls[0]).toEqual([mockPath00001])
  expect(fs.readFileSync.mock.calls[1]).toEqual([mockPath00002])
  expect(fs.readFileSync.mock.calls[2]).toEqual([mockPath00003])
  expect(fs.readFileSync.mock.calls[3]).toEqual([mockPath00004])

  // would expect 5 queries, but we're mocking getMigrationLevel()
  expect(repo.db.exec).toHaveBeenCalledTimes(4)
  expect(repo.db.exec.mock.calls[0]).toEqual([mockSql00001])
  expect(repo.db.exec.mock.calls[1]).toEqual([mockSql00002])
  expect(repo.db.exec.mock.calls[2]).toEqual([mockSql00003])
  expect(repo.db.exec.mock.calls[3]).toEqual([mockSql00004])
})

test("updateDb() runs only pending migrations at level 2", () => {
  path.join = jest.fn()
    .mockReturnValueOnce(mockMigrationDir)
    .mockReturnValueOnce(mockPath00003)
    .mockReturnValueOnce(mockPath00004)

  fs.readFileSync = jest.fn()
    .mockReturnValueOnce(mockSql00003)
    .mockReturnValueOnce(mockSql00004)

  repo.getMigrationLevel = jest.fn().mockReturnValue(2)
  repo.updateDb()

  expect(path.join).toHaveBeenCalledTimes(3)

  expect(path.join.mock.calls[1]).toEqual([mockMigrationDir, mockMigration00003])
  expect(path.join.mock.calls[2]).toEqual([mockMigrationDir, mockMigration00004])

  expect(fs.readFileSync).toHaveBeenCalledTimes(2)
  expect(fs.readFileSync.mock.calls[0]).toEqual([mockPath00003])
  expect(fs.readFileSync.mock.calls[1]).toEqual([mockPath00004])

  expect(repo.db.exec).toHaveBeenCalledTimes(2)
  expect(repo.db.exec.mock.calls[0]).toEqual([mockSql00003])
  expect(repo.db.exec.mock.calls[1]).toEqual([mockSql00004])
})

test("updateDb() throws error when db.exec throws error", () => {
  repo.db.exec = jest.fn().mockImplementation(() => {
    throw new Error("SQL failed")
  })
  repo.getMigrationLevel = jest.fn().mockReturnValue(3)

  expect(() => {
    const level = repo.updateDb()
  }).toThrow()
})

test("validateResult() throws version mismatch with stale version", () => {
  const mockChanges = { changes: 0 }
  const mockId = "mockId"
  const origVersion = "original version"
  const newVersion = "new version"
  repo.db.get.mockReturnValueOnce({
    id: mockId,
    version: newVersion
  })
  const versionedObject = {
    id: mockId,
    version: origVersion
  }

  try {
    repo.validateResult(mockChanges, versionedObject, "vobj")
  }
  catch (e) {
    expect(e.message).toBe("version mismatch")
  }
})

test("validateResult() throws id mismatch with invalid id", () => {
  const mockChanges = { changes: 0 }
  const mockId = "mockId"
  const origVersion = "original version"
  const newVersion = "new version"
  repo.db.get.mockReturnValueOnce(undefined)
  const versionedObject = {
    idField: "not mock id",
    version: origVersion
  }

  try {
    repo.validateResult(mockChanges, versionedObject, "vobj")
  }
  catch (e) {
    expect(e.message).toBe("id mismatch")
  }
})

test("validateResult() updates object version when there are changes", () => {
  const mockChanges = { changes: 1 }
  const mockId = "mock id"
  const origVersion = "original version"
  const newVersion = "new version"
  repo.db.get.mockReturnValueOnce({
    id: mockId,
    version: newVersion
  })
  const versionedObject = {
    id: mockId,
    version: origVersion
  }

  repo.validateResult(mockChanges, versionedObject, "vobj")

  expect(versionedObject.version).toBe(newVersion)
})

test("repo.account is an AccountRepo", () => {
  expect(repo.account.constructor.name).toBe("AccountRepo")
})

test("repo.apiKey is an ApiKeyRepo", () => {
  expect(repo.apiKey.constructor.name).toBe("ApiKeyRepo")
})

test("repo.commodity is a CommodityRepo", () => {
  expect(repo.commodity.constructor.name).toBe("CommodityRepo")
})

test("repo.ofx is a OfxRepo", () => {
  expect(repo.ofx.constructor.name).toBe("OfxRepo")
})

test("repo.price is a PriceRepo", () => {
  expect(repo.price.constructor.name).toBe("PriceRepo")
})

test("repo.tx is a TxRepo", () => {
  expect(repo.tx.constructor.name).toBe("TxRepo")
})