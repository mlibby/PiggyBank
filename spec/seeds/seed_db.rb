require_relative "commodities"
require_relative "accounts"
require_relative "prices"
require_relative "tx"

def seed_db
  PiggyBank::Split.truncate
  PiggyBank::Tx.truncate
  PiggyBank::Account.truncate
  PiggyBank::Price.truncate
  PiggyBank::Commodity.truncate
  seed_commodities
  seed_accounts
  seed_prices
  seed_tx
end