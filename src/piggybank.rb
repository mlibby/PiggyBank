#require "date"
require "sinatra/base"
#require "sequel"
#require "sequel/extensions/seed"

module PiggyBank
  class App < Sinatra::Base
    # if (ENV["DEMO"])
    #   DB = Sequel.connect(ENV["DATABASE_URL"])
    # else
    #   DB = Sequel.connect("sqlite://piggybank.sqlite")
    # end

    # Sequel.extension :migration
    # Sequel::Migrator.run(DB, __dir__ + "/db/migrations")

    # require_relative "./db/piggybank.rb"
    # Sequel.extension :seed
    # Sequel::Seeder.apply(DB, __dir__ + "/db/seeds")

    set :public_folder, __dir__ + "/www"

    require_relative("./controllers/account")
    require_relative("./controllers/budget")
    require_relative("./controllers/commodity")
    require_relative("./controllers/data")
    require_relative("./controllers/home.rb")
    require_relative("./controllers/price")
    require_relative("./controllers/report")
    require_relative("./controllers/settings")
    require_relative("./controllers/tool")
    require_relative("./controllers/tx")

    run! if app_file == $0
  end
end
