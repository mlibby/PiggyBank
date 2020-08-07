CREATE VIEW current_price AS
SELECT
  p.id,
  p.value
FROM
  price p
  JOIN (
    SELECT
      price.id,
      max(price.quoteDate) AS quoteDate
    FROM
      price
    GROUP BY
      price.id
  ) d ON p.commodityId = d.id
  AND p.quoteDate = d.quoteDate;

-- set migration
UPDATE
  migration
SET
  LEVEL = 5;