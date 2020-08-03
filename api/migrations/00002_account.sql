DROP INDEX IF EXISTS accountNameParent;

DROP TABLE IF EXISTS account;

DROP TABLE IF EXISTS price;

DROP TABLE IF EXISTS commodity;

CREATE TABLE commodity (
  "commodityId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "type" INTEGER NOT NULL,
  "symbol" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "ticker" TEXT,
  "version" TEXT NOT NULL
);

CREATE INDEX commodityTypeName ON commodity ("type", "name");

INSERT INTO
  commodity (
    "type",
    "symbol",
    "name",
    "description",
    "version"
  )
VALUES
  (1, '$', 'USD', 'US Dollar', getVersion());

CREATE TABLE price (
  "priceId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "currencyId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "commodityId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "quoteDate" TEXT NOT NULL,
  "value" NUMERIC NOT NULL,
  "version" TEXT NOT NULL
);

CREATE INDEX priceCurrCommDate ON price ("currencyId", "commodityId", "quoteDate");

WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  price (
    "currencyId",
    "commodityId",
    "value",
    "quoteDate",
    "version"
  )
SELECT
  cid,
  cid,
  1,
  '1970-01-01T00:00:00.000Z',
  getVersion()
FROM
  c;

CREATE TABLE account (
  "accountId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "currencyId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "name" TEXT NOT NULL,
  "isPlaceholder" BOOLEAN NOT NULL DEFAULT FALSE,
  "parentId" INTEGER,
  "version" TEXT NOT NULL
);

CREATE UNIQUE INDEX accountNameParent ON account("name", "parentId");

-- Required top-level accounts
WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  account (
    "name",
    "isPlaceholder",
    "currencyId",
    "version"
  )
SELECT
  'Assets',
  TRUE,
  cid,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  account (
    "name",
    "isPlaceholder",
    "currencyId",
    "version"
  )
SELECT
  'Equity',
  TRUE,
  cid,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  account (
    "name",
    "isPlaceholder",
    "currencyId",
    "version"
  )
SELECT
  'Expenses',
  TRUE,
  cid,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  account (
    "name",
    "isPlaceholder",
    "currencyId",
    "version"
  )
SELECT
  'Income',
  TRUE,
  cid,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  account (
    "name",
    "isPlaceholder",
    "currencyId",
    "version"
  )
SELECT
  'Liabilities',
  TRUE,
  cid,
  getVersion()
FROM
  c;

-- set migration
UPDATE
  migration
SET
  LEVEL = 2;