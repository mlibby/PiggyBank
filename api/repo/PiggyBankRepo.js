const fs = require("fs")
const path = require("path")

class PiggyBankRepo {
  constructor(pool, readdir = fs.readdirSync, readfile = fs.readFileSync, pathJoin = path.join) {
    this.pool = pool
    this.pathJoin = pathJoin
    this.readdir = readdir
    this.readfile = readfile
  }

  async query(sql, values) {
    const client = await this.pool.connect()
    let results = await client.query(sql, values)
    client.release()
    return results
  }

  async getMigrationLevel() {
    const sql = 'select max(level) from migration'
    let level = 0
    try {
      level = await this.query(sql)
    }
    catch (error) {
      if(error.message !== 'relation "migration" does not exist') {
        throw error
      }
    }
    return 0;
  }

  async updateDb() {
    console.log("updating DB")
  }
}

module.exports = PiggyBankRepo;