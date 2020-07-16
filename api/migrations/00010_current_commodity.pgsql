CREATE OR REPLACE VIEW current_commodity
AS
SELECT
	s.commodity_id,
    c.name,
	SUM(amount) amount
FROM split s
JOIN commodity c
ON s.commodity_id = c.commodity_id
WHERE c.commodity_type = 1
GROUP BY s.commodity_id, c.name;

-- set migration
UPDATE
    migration
SET
    level = 10;