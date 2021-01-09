require "sinatra"
require "sequel"
require "sqlite3"

DB = Sequel.connect("sqlite://piggybank.db")
Sequel.extension :migration
Sequel::Migrator.run(DB, "src/db/migrations")

get "/" do
  "Oink! Oink!"
end

get "/account" do
  accounts = DB[:account].all.to_s
  accounts
end
