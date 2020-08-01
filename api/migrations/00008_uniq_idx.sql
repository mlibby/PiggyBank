-- ALTER TABLE
--   price
-- ADD
--   UNIQUE("currencyId", "commodityId", "quoteDate");

-- ALTER TABLE
--   account
-- ADD
--   UNIQUE("parentId", "accountName");

-- ALTER TABLE
--   api_key
-- ADD
--   UNIQUE("description");

-- ALTER TABLE
--   commodity
-- ADD
--   UNIQUE("commodityType", "name");

-- set migration
UPDATE
  migration
SET
  LEVEL = 8;