require "date"
require "sequel"
require "sequel/extensions/seed"

module PiggyBank
  class Repo
    attr_reader :accounts, :commodities

    def initialize(db_connection)
      @db = Sequel::Model.db = Sequel.connect db_connection

      Sequel.extension :migration
      Sequel::Migrator.run @db, "#{__dir__}/migrations"

      require_relative "./models/setting"
      require_relative "./models/commodity"
      require_relative "./models/account"
      require_relative "./models/price"
      require_relative "./models/split"
      require_relative "./models/tx"
      require_relative "./models/api_key"
      require_relative "./models/ofx"
      require_relative "./models/blob"
      require_relative "./models/tax/data/general"
      require_relative "./models/tax/data/income"
      require_relative "./models/tax/data/deduct"

      if ENV["APP_ENV"] != "TEST"
        # :nocov:
        Sequel.extension :seed
        Sequel::Seeder.apply @db, "#{__dir__}/seeds"
        # :nocov:
      end

      if ["DEMO", "DUMP"].include? ENV["APP_ENV"] 
        require_relative "../../spec/seeds/seed_db"
        seed_db
      end
    end

    def Repo.timestamp
      DateTime.now.new_offset(0).to_s
    end
  end
end
