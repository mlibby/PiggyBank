-- SELECT
--   commodity_id INTO usd_id
-- FROM
--   commodity
-- WHERE
--   name = 'USD';

-- INSERT INTO
--   price (currency_id, commodity_id, value, quote_date)
-- VALUES
--   (usd_id, usd_id, 1, '1970-01-01');

-- -- set migration
-- UPDATE
--   migration
-- SET
--   LEVEL = 11;