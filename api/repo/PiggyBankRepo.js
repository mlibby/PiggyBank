const fs = require("fs")
const path = require("path")
const SQLite3 = require("better-sqlite3")

const { AccountRepo } = require("./AccountRepo")
const { ApiKeyRepo } = require("./ApiKeyRepo")
const { CommodityRepo } = require("./CommodityRepo")
const { OfxRepo } = require("./OfxRepo")
const { PriceRepo } = require("./PriceRepo")
const { TxRepo } = require("./TxRepo")

exports.PiggyBankRepo = class PiggyBankRepo {
  constructor() {
    this.db = new SQLite3("piggybank.db")
    this.db.pragma("foreign_keys = ON")
    this.db.function('getVersion', this.getVersion)

    this.account = new AccountRepo(this.db, this.validateResult)
    this.apiKey = new ApiKeyRepo(this.db, this.validateResult)
    this.commodity = new CommodityRepo(this.db)
    this.ofx = new OfxRepo(this.db)
    this.price = new PriceRepo(this.db)
    this.tx = new TxRepo(this.db)
  }

  getVersion() {
    return (new Date()).toISOString()
  }

  getMigrationLevel() {
    const sql = 'select max(level) from migration'
    let level = 0
    try {
      const stmt = this.db.prepare(sql)
      level = stmt.pluck().get()
    }
    catch (err) {
      if (err.message !== 'no such table: migration') {
        throw err
      }
    }

    return level
  }

  updateDb() {
    console.log("checking for pending migrations")
    const migrationDir = path.join(__dirname, "../migrations")
    const migrationLevel = this.getMigrationLevel()
    const migrations = fs.readdirSync(migrationDir)
    const pending = migrations.filter((f) => {
      return /^\d{5}/.test(f) && Number(f.substr(0, 5)) > migrationLevel
    });

    pending.forEach((f) => {
      console.log(`running migration ${f}`)
      const migrationPath = path.join(migrationDir, f)
      const sql = fs.readFileSync(migrationPath).toString()
      try {
        this.db.exec(sql)
      }
      catch (err) {
        console.log(err.message)
        throw err
      }
    })
  }

  validateResult(result, original, table) {
    // WARNING: 
    // there is a potential race condition in this code
    // if another user updates or deletes a record with
    // the relevant ID then this will either pull back
    // a version number that doesn't match the state of
    // object or this will silently fail to update the 
    // version number of the object
    // NOTE:
    // is this a real problem given that the first update
    // would prevent the second update from working via
    // the version number mismatch?

    if (result.changes > 0) {
      const stmt = this.db.prepare(`
        SELECT "id", "version"
        FROM ${table}
        WHERE "id" = ?
      `)
      const updated = this.db.get(original["id"])
      if (updated) {
        original.version = updated.version
      }
    }
    else {
      this.validateVersion(original, table)
    }
  }

  validateVersion(original, table) {
    const stmt = this.db.prepare(`
      SELECT
        "id",
        "version"
      FROM ${table}
      WHERE "id" = ?
      `)

    const result = stmt.get(original["id"])
    if (result && result.version !== original.version) {
      throw new Error("version mismatch")
    }
    else {
      throw new Error("id mismatch")
    }
  }
}
