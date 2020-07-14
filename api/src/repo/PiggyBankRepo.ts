import pg from "pg";
import fs from "fs";
import path, { PlatformPath } from "path";

export class PiggyBankRepo {
  readdir: Function;
  readfile: Function;
  path: PlatformPath;
  pool: pg.Pool;

  constructor(
    pool: pg.Pool,
    readdir: Function = fs.readdirSync,
    readfile: Function = fs.readFileSync,
    pathModule: PlatformPath = path) {
    this.pool = pool;
    this.path = pathModule;
    this.readdir = readdir;
    this.readfile = readfile;
  }

  async updateDb() {
    console.log("updating DB");
  }
}