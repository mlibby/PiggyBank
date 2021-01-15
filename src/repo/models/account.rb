module PiggyBank
  class Account < Sequel::Model(:account)
    TYPE_CODE = {
      "Asset" => 1,
      "Liability" => 2,
      "Equity" => 3,
      "Income" => 4,
      "Expense" => 5,
      "Mortgage" => 6
    }

    # primary_key :account_id
    # foreign_key :parent_id, :account, key: [:account_id]
    # foreign_key :commodity_id, :commodity, null: false, key: [:id]
    # String :name, text: true, null: false
    # TrueClass :is_placeholder, default: false, null: false
    # Integer :type, null: false
    # String :typeData, text: true
    # String :version, text: true, null: false
  end
end
