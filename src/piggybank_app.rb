require "sinatra/base"
require_relative "repo/piggybank_repo.rb"

module PiggyBank
  class App < Sinatra::Base
    db_connections = {
      "DEV" => "sqlite://piggybank.sqlite",
      "TEST" => "sqlite:/",
      "PROD" => "sqlite://piggybank.sqlite",
      "DEMO" => ENV["DATABASE_URL"],
    }

    @@repo = PiggyBank::Repo.new db_connections[ENV["APP_ENV"] || "DEV"]

    set :public_folder, "#{__dir__}/www"

    require_relative "./controllers/account"
    require_relative "./controllers/budget"
    require_relative "./controllers/commodity"
    require_relative "./controllers/data"
    require_relative "./controllers/home.rb"
    require_relative "./controllers/price"
    require_relative "./controllers/report"
    require_relative "./controllers/settings"
    require_relative "./controllers/tool"
    require_relative "./controllers/tx"

    run! if app_file == $0
  end
end
