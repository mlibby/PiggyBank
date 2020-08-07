DROP TABLE IF EXISTS ofx;

CREATE TABLE ofx (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "active" BOOLEAN NOT NULL DEFAULT FALSE,
  "accountId" INTEGER NOT NULL REFERENCES account (id),
  "url" TEXT NOT NULL DEFAULT '',
  "user" TEXT NOT NULL DEFAULT '',
  "password" TEXT NOT NULL DEFAULT '',
  "fid" INTEGER NOT NULL,
  "fidOrg" TEXT NOT NULL,
  "bankId" TEXT NOT NULL DEFAULT '',
  "bankAccountId" TEXT NOT NULL,
  "accountType" TEXT NOT NULL,
  "version" TEXT NOT NULL
);

DROP TABLE IF EXISTS ofx_import;

CREATE TABLE ofx_import (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "ofxId" INTEGER NOT NULL REFERENCES ofx (id),
  "downloaded" TEXT NOT NULL,
  "startDate" TEXT NOT NULL,
  "endDate" TEXT NOT NULL,
  "txCount" INTEGER NOT NULL,
  "txLoaded" INTEGER NOT NULL,
  "balance" NUMERIC,
  "balanceDate" TEXT,
  "version" TEXT NOT NULL
);

-- set migration
UPDATE
  migration
SET
  LEVEL = 7;