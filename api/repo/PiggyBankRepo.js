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

    this.account = new AccountRepo(this.query.bind(this))
    this.commodity = new CommodityRepo(this.query.bind(this))
    this.apiKey = new ApiKeyRepo(this.query.bind(this))
    this.ofx = new OfxRepo(this.query.bind(this))
    this.price = new PriceRepo(this.query.bind(this))
    this.tx = new TxRepo(this.query.bind(this))
  }

  getMigrationLevel() {
    const sql = 'select max(level) from migration'
    let level = 0
    try {
      const stmt = this.db.prepare(sql)
      level = stmt.pluck().get()
    }
    catch (err) {
      if (err.message !== 'relation "migration" does not exist') {
        throw err
      }
    }
    
    return level
  }

  updateDb() {
    console.log("checking for pending migrations")
    const migrationDir = path.join(__dirname, "../migrations")
    const migrationLevel = this.getMigrationLevel()
    const migrations = fs.readdir(migrationDir)
    const pending = migrations.filter((f) => {
      return /^\d{5}/.test(f) && Number(f.substr(0, 5)) > migrationLevel
    });

    pending.forEach(async (f) => {
      console.log(`running migration ${f}`)
      const migrationPath = path.join(migrationDir, f)
      const sql = fs.readfile(migrationPath)
      this.query(sql)
    })
  }
}
