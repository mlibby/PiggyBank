const fs = require("fs");
const path = require("path");

class PiggyBankRepo {
  constructor(pool, readdir = fs.readdirSync, readfile = fs.readFileSync, pathJoin = path.join) {
    this.pool = pool;
    this.pathJoin = pathJoin;
    this.readdir = readdir;
    this.readfile = readfile;
  }

  async query(sql, values) {
    const client = await this.pool.connect();
    const results = await client.query(sql, values);
    client.release();
    return results;
  }

  async updateDb() {
    console.log("updating DB");
  }
}

module.exports = PiggyBankRepo;