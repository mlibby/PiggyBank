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

      require_relative "./models/account.rb"
      require_relative "./models/commodity.rb"

      Sequel.extension :seed
      Sequel::Seeder.apply @db, "#{__dir__}/seeds"
    end

    def Repo.timestamp
      DateTime.now.new_offset(0).to_s
    end
  end
end
