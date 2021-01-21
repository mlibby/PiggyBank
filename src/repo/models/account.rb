module PiggyBank
  # primary_key :account_id
  # foreign_key :parent_id, :account, key: [:account_id]
  # foreign_key :commodity_id, :commodity, null: false, key: [:commodity_id]
  # String :name, text: true, null: false
  # TrueClass :is_placeholder, default: false, null: false
  # Integer :type, null: false
  # String :type_data, text: true
  # String :version, text: true, null: false
  class Account < Sequel::Model(:account)
    one_to_many :subaccounts, class: self, key: :parent_id
    many_to_one :commodity, class: PiggyBank::Commodity

     TYPE = {
      asset: 1,
      liability: 2,
      equity: 3,
      income: 4,
      expense: 5,
      mortgage: 6
    }

    def Account.as_chart
      chart = Account.where(parent_id: nil).all
    end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

  end
end
