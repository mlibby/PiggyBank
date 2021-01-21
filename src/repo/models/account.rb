module PiggyBank
  class Account < Sequel::Model(:account)
    TYPE_CODE = {
      asset: 1,
      liability: 2,
      equity: 3,
      income: 4,
      expense: 5,
      mortgage: 6
    }

    # primary_key :account_id
    # foreign_key :parent_id, :account, key: [:account_id]
    # foreign_key :commodity_id, :commodity, null: false, key: [:id]
    # String :name, text: true, null: false
    # TrueClass :is_placeholder, default: false, null: false
    # Integer :type, null: false
    # String :typeData, text: true
    # String :version, text: true, null: false

    def Account.as_chart
      chart = Account.all
    end

  end
end
