require "date"
require "pp"
require "sinatra"
require "sequel"
require "sequel/extensions/seed"
require "sqlite3"

DB = Sequel.connect("sqlite://piggybank.sqlite")
Sequel.extension :migration
Sequel::Migrator.run(DB, "src/db/migrations")

require_relative "./db/piggybank.rb"
Sequel.extension :seed
Sequel::Seeder.apply(DB, "src/db/seeds")

set :public_folder, __dir__ + "/www"

get "/" do
  erb :"home/index", layout: :layout
end

get "/account" do
  erb :"account/index",
      layout: :layout,
      locals: { accounts: pp(DB[:account].all) }
end

get "/commodity" do
  erb :"commodity/index",
      layout: :layout,
      locals: { commodities: pp(DB[:commodity].all) }
end
