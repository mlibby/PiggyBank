DROP TABLE IF EXISTS price;

CREATE TABLE price (
  "priceId" INTEGER PRIMARY KEY AUTOINCREMENT,
  "currencyId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "commodityId" INTEGER NOT NULL REFERENCES commodity (commodityId),
  "quoteTimestamp" TEXT NOT NULL,
  "value" NUMERIC NOT NULL
);

-- set migration
UPDATE
  migration
SET
  LEVEL = 6;