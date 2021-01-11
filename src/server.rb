require "date"
require "pp"
require "sinatra"
require "sequel"
require "sequel/extensions/seed"

if (ENV["DEMO"])
  DB = Sequel.connect(ENV["DATABASE_URL"])
else
  DB = Sequel.connect("sqlite://piggybank.sqlite")
end

Sequel.extension :migration
Sequel::Migrator.run(DB, __dir__ + "/db/migrations")

require_relative "./db/piggybank.rb"
Sequel.extension :seed
Sequel::Seeder.apply(DB, __dir__ + "/db/seeds")

set :public_folder, __dir__ + "/www"

get "/" do
  erb :"home/index", layout: :layout
end

require_relative("./routes/account")
require_relative("./routes/budget")
require_relative("./routes/commodity")
require_relative("./routes/data")
require_relative("./routes/price")
require_relative("./routes/report")
require_relative("./routes/settings")
require_relative("./routes/tool")
require_relative("./routes/tx")
