require_relative "model.rb"

module PiggyBank
  class Commodity < Model
    @@table = :commodity

    CURRENCY = 1
    INVESTMENT = 2

    # Integer :type, null: false
    # String :name, text: true, null: false
    # String :description, text: true, null: false
    # String :ticker, text: true
    # Integer :fraction, null: false
    # String :version, text: true, null: false
    def create(attributes)
      @attributes = attributes
      @db[@@table].insert attributes
    end
  end
end
