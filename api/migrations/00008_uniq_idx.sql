ALTER TABLE price ADD UNIQUE(currency_id, commodity_id, quote_date);

ALTER TABLE account ADD UNIQUE(parent_id, account_name);

ALTER TABLE api_key ADD UNIQUE(description);

ALTER TABLE commodity ADD UNIQUE(commodity_type, name);

-- set migration
UPDATE
    migration
SET
    level = 8;