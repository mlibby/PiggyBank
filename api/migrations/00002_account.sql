DROP INDEX IF EXISTS accountNameParent;

DROP TABLE IF EXISTS account;

DROP TABLE IF EXISTS price;

DROP TABLE IF EXISTS commodity;

CREATE TABLE commodity (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "type" INTEGER NOT NULL,
  "name" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "ticker" TEXT,
  "fraction" INTEGER NOT NULL,
  "version" TEXT NOT NULL
);

CREATE INDEX commodityTypeName ON commodity ("type", "name");

INSERT INTO
  commodity (
    "type",
    "name",
    "description",
    "ticker",
    "fraction",
    "version"
  )
VALUES
  (
    1,
    'USD',
    'US Dollar',
    'USD',
    100,
    getVersion()
  );

CREATE TABLE price (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "currencyId" INTEGER NOT NULL REFERENCES commodity (id),
  "commodityId" INTEGER NOT NULL REFERENCES commodity (id),
  "quoteDate" TEXT NOT NULL,
  "value" NUMERIC NOT NULL,
  "version" TEXT NOT NULL
);

CREATE INDEX priceCurrCommDate ON price ("currencyId", "commodityId", "quoteDate");

WITH c (cid) AS (
  SELECT
    id
  FROM
    commodity
  WHERE
    name = 'USD'
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
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "parentId" INTEGER,
  "commodityId" INTEGER NOT NULL REFERENCES commodity (id),
  "name" TEXT NOT NULL,
  "isPlaceholder" BOOLEAN NOT NULL DEFAULT FALSE,
  "type" INTEGER NOT NULL,
  "typeData" TEXT,
  "version" TEXT NOT NULL
);

CREATE UNIQUE INDEX accountNameParent ON account("name", "parentId");

-- Required top-level accounts
WITH c (cid) AS (
  SELECT
    id
  FROM
    commodity
  WHERE
    name = 'USD'
)
INSERT INTO
  account (
    "commodityId",
    "name",
    "isPlaceholder",
    "type",
    "version"
  )
SELECT
  cid,
  'Assets',
  TRUE,
  1,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    id
  FROM
    commodity
  WHERE
    name = 'USD'
)
INSERT INTO
  account (
    "commodityId",
    "name",
    "isPlaceholder",
    "type",
    "version"
  )
SELECT
  cid,
  'Equity',
  TRUE,
  2,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    id
  FROM
    commodity
  WHERE
    name = 'USD'
)
INSERT INTO
  account (
    "commodityId",
    "name",
    "isPlaceholder",
    "type",
    "version"
  )
SELECT
  cid,
  'Expenses',
  TRUE,
  3,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    id
  FROM
    commodity
  WHERE
    name = 'USD'
)
INSERT INTO
  account (
    "commodityId",
    "name",
    "isPlaceholder",
    "type",
    "version"
  )
SELECT
  cid,
  'Income',
  TRUE,
  4,
  getVersion()
FROM
  c;

WITH c (cid) AS (
  SELECT
    id
  FROM
    commodity
  WHERE
    name = 'USD'
)
INSERT INTO
  account (
    "commodityId",
    "name",
    "isPlaceholder",
    "type",
    "version"
  )
SELECT
  cid,
  'Liabilities',
  TRUE,
  5,
  getVersion()
FROM
  c;

-- set migration
UPDATE
  migration
SET
  LEVEL = 2;