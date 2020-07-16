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
    let results = await client.query(sql, values);
    client.release();
    return results;
  }

  async getMigrationLevel() {
    const sql = 'select max(level) from migration';
    let level = 0;
    let results = null;
    try {
      results = await this.query(sql);
    }
    catch (err) {
      if (err.message !== 'relation "migration" does not exist') {
        throw err;
      }
    }

    if (results) {
      level = Number(results.rows[0].max);
    }

    return level;
  }

  async updateDb() {
    console.log("checking for pending migrations");
    const migrationDir = this.pathJoin(__dirname, "../migrations");
    const migrationLevel = this.getMigrationLevel();
    const migrations = this.readdir(migrationDir);
    const pending = migrations.filter((f) => {
       return /^\d{5}/.test(f) && Number(f.substr(0, 5)) > migrationLevel
    });

    pending.forEach(async (f) => {
      console.log(`running migration ${f}`);
      const migrationPath = this.pathJoin(migrationDir, f);
      const sql = this.readfile(migrationPath);
      await this.query(sql);
    });
  }
}

module.exports = PiggyBankRepo;