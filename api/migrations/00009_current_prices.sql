CREATE OR REPLACE VIEW current_price
AS
SELECT
    p.commodity_id,
    p.value
FROM price p
JOIN ( 
    SELECT 
        price.commodity_id,
        max(price.quote_date) AS quote_date
    FROM price
    GROUP BY price.commodity_id
) d 
ON p.commodity_id = d.commodity_id AND p.quote_date = d.quote_date;

-- set migration
UPDATE
    migration
SET
    level = 9;