ALTER TABLE price DROP COLUMN quote_timestamp;

ALTER TABLE price ADD COLUMN quote_date DATE NOT NULL;

-- set migration
UPDATE
    migration
SET
    level = 7;