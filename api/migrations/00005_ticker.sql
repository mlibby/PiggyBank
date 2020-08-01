ALTER TABLE
  commodity RENAME COLUMN cusip TO ticker;

-- set migration
UPDATE
  migration
SET
  LEVEL = 5;