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

      require_relative "./models/setting.rb"
      require_relative "./models/commodity.rb"
      require_relative "./models/account.rb"
      require_relative "./models/price.rb"
      require_relative "./models/split.rb"
      require_relative "./models/tx.rb"
      require_relative "./models/api_key.rb"
      require_relative "./models/ofx.rb"
      require_relative "./models/blob.rb"
      require_relative "./models/tax_general.rb"
      require_relative "./models/tax_income.rb"

      if ENV["APP_ENV"] != "TEST"
        # :nocov:
        Sequel.extension :seed
        Sequel::Seeder.apply @db, "#{__dir__}/seeds"
        # :nocov:
      end
    end

    def Repo.timestamp
      DateTime.now.new_offset(0).to_s
    end
  end
end
