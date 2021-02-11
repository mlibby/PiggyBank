require_relative "commodities"
require_relative "accounts"
require_relative "prices"
require_relative "tx"
require_relative "api_key"
require_relative "ofx"
require_relative "blobs"

def seed_db
  PiggyBank::Ofx.truncate
  PiggyBank::Split.truncate
  PiggyBank::Tx.truncate
  PiggyBank::Account.truncate
  PiggyBank::Price.truncate
  PiggyBank::Commodity.truncate
  PiggyBank::ApiKey.truncate
  PiggyBank::Blob.truncate
  
  seed_commodities
  seed_accounts
  seed_prices
  seed_tx
  seed_api_keys
  seed_ofx
  seed_blobs
end