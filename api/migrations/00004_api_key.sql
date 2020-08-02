DROP TABLE IF EXISTS api_key;

CREATE TABLE IF NOT EXISTS api_key (
  "apiKeyId" INTEGER PRIMARY KEY AUTOINCREMENT,
  "description" TEXT NOT NULL UNIQUE,
  "apiKeyValue" TEXT NOT NULL,
  "version" TEXT NOT NULL
);

INSERT INTO
  api_key ("description", "apiKeyValue", "version")
VALUES
  ('www.alphavantage.co', '', getVersion());

-- set migration
UPDATE
  migration
SET
  LEVEL = 4;