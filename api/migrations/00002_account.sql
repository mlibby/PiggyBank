DO $$DECLARE usd_id INTEGER;
BEGIN	
DROP TABLE IF EXISTS commodity;

CREATE TABLE commodity (
    commodity_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    commodity_type INTEGER NOT NULL,
    symbol TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    cusip TEXT
);

INSERT INTO commodity (commodity_type, symbol, name, description)
    VALUES (0, '$', 'USD', 'US Dollar');

SELECT commodity_id INTO usd_id FROM commodity WHERE symbol = '$';

DROP TABLE IF EXISTS price;

CREATE TABLE price (
    currency_id INTEGER NOT NULL REFERENCES commodity (commodity_id),
    commodity_id INTEGER NOT NULL REFERENCES commodity (commodity_id),
    quote_timestamp TIMESTAMP NOT NULL,
    value NUMERIC NOT NULL
);

DROP TABLE IF EXISTS account CASCADE;

CREATE TABLE account (
    account_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	currency_id INTEGER NOT NULL REFERENCES commodity (commodity_id),
    account_name TEXT NOT NULL,
    is_placeholder BOOLEAN NOT NULL DEFAULT FALSE,
    parent_id INTEGER
);

-- Required top-level accounts
INSERT INTO account (account_name, is_placeholder, currency_id)
    VALUES ('Assets', TRUE, usd_id);

INSERT INTO account (account_name, is_placeholder, currency_id)
    VALUES ('Equity', TRUE, usd_id);

INSERT INTO account (account_name, is_placeholder, currency_id)
    VALUES ('Expenses', TRUE, usd_id);

INSERT INTO account (account_name, is_placeholder, currency_id)
    VALUES ('Income', TRUE, usd_id);

INSERT INTO account (account_name, is_placeholder, currency_id)
    VALUES ('Liabilities', TRUE, usd_id);

-- set migration
UPDATE
    migration
SET
    level = 2;

END$$;