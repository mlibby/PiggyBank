require_relative "commodities"
require_relative "accounts"

def seed_db
  PiggyBank::Account.truncate
  PiggyBank::Commodity.truncate
  seed_commodities
  seed_accounts
end