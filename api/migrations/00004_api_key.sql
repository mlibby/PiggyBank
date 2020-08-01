DROP TABLE IF EXISTS api_key;

CREATE TABLE IF NOT EXISTS api_key (
  "apiKeyId" INTEGER PRIMARY KEY AUTOINCREMENT,
  "description" TEXT NOT NULL,
  "apiKeyValue" TEXT NOT NULL
);

INSERT INTO
  api_key ("description", "apiKeyValue")
VALUES
  ('www.alphavantage.co', '');

-- set migration
UPDATE
  migration
SET
  LEVEL = 4;