DROP TABLE IF EXISTS ledger_tx CASCADE;
DROP TABLE IF EXISTS tx CASCADE;

CREATE TABLE tx (
    tx_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    post_date DATE NOT NULL,
    number TEXT NULL,
    description TEXT NOT NULL
);

DROP TABLE IF EXISTS ledger_entry CASCADE;
DROP TABLE IF EXISTS split CASCADE;

CREATE TABLE IF NOT EXISTS split (
    split_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    tx_id INT NOT NULL REFERENCES tx (tx_id),
    account_id INT NOT NULL REFERENCES account (account_id),
    commodity_id INT NOT NULL REFERENCES commodity (commodity_id),
    memo TEXT NULL,
    amount NUMERIC NOT NULL,
    value NUMERIC NOT NULL
);

-- set migration
UPDATE
    migration
SET
    level = 3;