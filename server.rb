require "sinatra"
require "sequel"
require "sqlite3"

DB = Sequel.connect("sqlite://piggybank.db")

get "/" do
  "Oink! Oink!"
end

get "/account" do
  accounts = DB[:account].all.to_s
  accounts
end
