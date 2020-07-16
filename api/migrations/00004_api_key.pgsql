DROP TABLE IF EXISTS api_key CASCADE;

CREATE TABLE IF NOT EXISTS api_key (
    api_key_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    description TEXT NOT NULL,
    api_key_value TEXT NOT NULL
);

INSERT INTO api_key (description, api_key_value) VALUES ('www.alphavantage.co', '');

-- set migration
UPDATE
    migration
SET
    level = 4;