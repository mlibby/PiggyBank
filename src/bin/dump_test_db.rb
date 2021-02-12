ENV["APP_ENV"] = "DUMP"

require_relative "../piggybank_app"
require_relative "../../spec/seeds/seed_db"

seed_db
