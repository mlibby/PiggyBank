require "haml"
require "sinatra/base"
require "sinatra/flash"
require_relative "repo/piggybank_repo.rb"

module PiggyBank
  class App < Sinatra::Base
    enable :sessions
    register Sinatra::Flash
    # valid flash keys for PiggyBank: :info, :success, :danger

    db_connections = {
      "DEV" => "sqlite://piggybank.sqlite",
      "TEST" => "sqlite:/",
      "PROD" => "sqlite://piggybank.sqlite",
      "DEMO" => ENV["DATABASE_URL"],
    }

    @@repo = PiggyBank::Repo.new db_connections[ENV["APP_ENV"] || "DEV"]

    set :public_folder, "#{__dir__}/www"
    set :strict_paths, false
    set :method_override, true

    @@token = PiggyBank::Repo.timestamp
    def self.token
      @@token
    end

    @@require_token = ["DELETE", "POST", "PUT"] 
    before do
      if @@require_token.include?(request.env["REQUEST_METHOD"]) && !(params.has_key? "_token")
        halt 403, "CSRF Token Required"
      end
    end

    require_relative "./controllers/piggybank_controllers"
    require_relative "./lib/piggybank_lib"

    run! if app_file == $0
  end
end
