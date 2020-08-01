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

    this.account = new AccountRepo(this.db)
    this.commodity = new CommodityRepo(this.db)
    this.apiKey = new ApiKeyRepo(this.db)
    this.ofx = new OfxRepo(this.db)
    this.price = new PriceRepo(this.db)
    this.tx = new TxRepo(this.db)
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
      catch(err) {
        console.log(err.message)
        throw err
      }
    })
  }
}
