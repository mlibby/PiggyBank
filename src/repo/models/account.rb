require_relative "model.rb"

module PiggyBank
  class Account < Model
    @@table = :account

    TYPE_ASSET = 1
    TYPE_LIABILITY = 2
    TYPE_EQUITY = 3
    TYPE_INCOME = 4
    TYPE_EXPENSE = 5

    TYPE_MORTGAGE = 6

    # primary_key :account_id
    # foreign_key :parent_id, :account, key: [:account_id]
    # foreign_key :commodity_id, :commodity, null: false, key: [:id]
    # String :name, text: true, null: false
    # TrueClass :is_placeholder, default: false, null: false
    # Integer :type, null: false
    # String :typeData, text: true
    # String :version, text: true, null: false
    def create(attributes)
      @attributes = attributes
      @db[@@table].insert attributes
    end
  end
end
