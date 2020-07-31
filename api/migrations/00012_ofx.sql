DO $$ 
BEGIN
DROP TABLE IF EXISTS ofx;
CREATE TABLE ofx (
  ofx_id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  active boolean NOT NULL DEFAULT FALSE,
  account_id integer NOT NULL REFERENCES account (account_id),
  url text NOT NULL DEFAULT '',
  "user" text NOT NULL DEFAULT '',
  "password" text NOT NULL DEFAULT '',
  fid integer NOT NULL,
  fid_org text NOT NULL,
  bank_id text NOT NULL DEFAULT '',
  acct_id text NOT NULL,
  acct_type text NOT NULL
);
DROP TABLE IF EXISTS ofx_import;
CREATE TABLE ofx_import (
  ofx_import_id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  ofx_id integer NOT NULL REFERENCES ofx (ofx_id),
  downloaded text NOT NULL,
  start_date timestamp NOT NULL,
  end_date timestamp NOT NULL,
  tx_count integer NOT NULL,
  tx_loaded integer NOT NULL,
  balance numeric,
  balance_date timestamp
);
-- set migration
UPDATE migration
SET level = 12;
END $$;