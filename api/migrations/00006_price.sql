DROP TABLE IF EXISTS price;

CREATE TABLE price (
    price_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    currency_id INTEGER NOT NULL REFERENCES commodity (commodity_id),
    commodity_id INTEGER NOT NULL REFERENCES commodity (commodity_id),
    quote_timestamp TIMESTAMP NOT NULL,
    value NUMERIC NOT NULL
);

-- set migration
UPDATE
    migration
SET
    level = 6;