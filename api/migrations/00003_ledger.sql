DROP TABLE IF EXISTS ledger_entry;

DROP TABLE IF EXISTS split;

DROP TABLE IF EXISTS ledger_tx;

DROP TABLE IF EXISTS tx;

CREATE TABLE IF NOT EXISTS tx (
  "txId" INTEGER PRIMARY KEY AUTOINCREMENT,
  "postDate" TEXT NOT NULL,
  "number" TEXT NULL,
  "description" TEXT NOT NULL,
  "version" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS split (
  "splitId" INTEGER PRIMARY KEY AUTOINCREMENT,
  "txId" INTEGER NOT NULL REFERENCES tx (txId),
  "accountId" INTEGER NOT NULL REFERENCES account (accountId),
  "commodityId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "memo" TEXT NULL,
  "amount" NUMERIC NOT NULL,
  "value" NUMERIC NOT NULL,
  "version" TEXT NOT NULL
);

-- set migration
UPDATE
  migration
SET
  level = 3;