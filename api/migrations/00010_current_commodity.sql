CREATE VIEW current_commodity AS
SELECT
  s.commodityId,
  c.name,
  SUM(amount) amount
FROM
  split s
  JOIN commodity c ON s.commodityId = c.commodityId
WHERE
  c.commodityType = 1
GROUP BY
  s.commodityId,
  c.name;

-- set migration
UPDATE
  migration
SET
  LEVEL = 10;