CREATE VIEW current_price AS
SELECT
  p.commodityId,
  p.value
FROM
  price p
  JOIN (
    SELECT
      price.commodityId,
      max(price.quoteDate) AS quoteDate
    FROM
      price
    GROUP BY
      price.commodityId
  ) d ON p.commodityId = d.commodityId
  AND p.quoteDate = d.quoteDate;

-- set migration
UPDATE
  migration
SET
  LEVEL = 5;