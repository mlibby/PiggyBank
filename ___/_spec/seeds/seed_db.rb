require_relative "commodities"
require_relative "accounts"
require_relative "prices"
require_relative "tx"
require_relative "api_key"
require_relative "ofx"
require_relative "blobs"

def seed_db
  PiggyBank::Ofx.dataset.delete
  PiggyBank::Split.dataset.delete
  PiggyBank::Tx.dataset.delete
  PiggyBank::Account.dataset.delete
  PiggyBank::Price.dataset.delete
  PiggyBank::Commodity.dataset.delete
  PiggyBank::ApiKey.dataset.delete
  PiggyBank::Blob.dataset.delete
  
  seed_commodities
  seed_accounts
  seed_prices
  seed_tx
  seed_api_keys
  seed_ofx
  seed_blobs
end