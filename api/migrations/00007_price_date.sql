-- ALTER TABLE
--   price DROP COLUMN quoteTimestamp;

-- ALTER TABLE
--   price
-- ADD
--   COLUMN quoteDate DATE NOT NULL;

-- set migration
UPDATE
  migration
SET
  LEVEL = 7;