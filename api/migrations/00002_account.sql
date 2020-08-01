DROP INDEX IF EXISTS accountNameParent;

DROP TABLE IF EXISTS account;

DROP TABLE IF EXISTS price;

DROP TABLE IF EXISTS commodity;

CREATE TABLE commodity (
  "commodityId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "commodityType" INTEGER NOT NULL,
  "symbol" TEXT NOT NULL UNIQUE,
  "name" TEXT NOT NULL UNIQUE,
  "description" TEXT NOT NULL,
  "cusip" TEXT
);

INSERT INTO
  commodity ("commodityType", "symbol", "name", "description")
VALUES
  (1, '$', 'USD', 'US Dollar');

SELECT
  commodityId INTO usdId
FROM
  commodity
WHERE
  symbol = '$';

CREATE TABLE price (
  "priceId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "currencyId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "commodityId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "quoteTimestamp" TIMESTAMP NOT NULL,
  "value" NUMERIC NOT NULL,
  FOREIGN KEY (currencyId) REFERENCES
);

CREATE TABLE account (
  "accountId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "currencyId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "accountName" TEXT NOT NULL,
  "isPlaceholder" BOOLEAN NOT NULL DEFAULT FALSE,
  "parentId" INTEGER,
);

CREATE UNIQUE INDEX accountNameParent ON account(accountName, parentId);

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
  account (accountName, isPlaceholder, currencyId)
SELECT
  'Assets',
  TRUE,
  cid
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
  account (accountName, isPlaceholder, currencyId)
SELECT
  'Equity',
  TRUE,
  cid
FROM
  c;

VALUES
  ('Equity', TRUE, usd_id);

WITH c (cid) AS (
  SELECT
    commodityId
  FROM
    commodity
  WHERE
    symbol = '$'
)
INSERT INTO
  account (accountName, isPlaceholder, currencyId)
SELECT
  'Expenses',
  TRUE,
  cid
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
  account (accountName, isPlaceholder, currencyId)
SELECT
  'Income',
  TRUE,
  cid
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
  account (accountName, isPlaceholder, currencyId)
SELECT
  'Liabilities',
  TRUE,
  cid
FROM
  c;

-- set migration
UPDATE
  migration
SET
  LEVEL = 2;