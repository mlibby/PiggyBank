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
    many_to_one :parent, class: self
    many_to_one :commodity, class: PiggyBank::Commodity

    TYPE = {
      asset: 1,
      liability: 2,
      equity: 3,
      income: 4,
      expense: 5,
      mortgage: 6,
    }

    def self.update_fields
      return [:type, :type_data, :name, :parent_id, :commodity_id, :is_placeholder]
    end
    
    def self.as_chart
      chart = Account.where(parent_id: nil).all
    end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def has_subaccounts?
      self.subaccounts.length > 0
    end

    def account_opts
      PiggyBank::Account.all.map do |account| 
        {
          text: account.long_name,
          value: account.account_id,
          selected: account.account_id == self.account_id
        }
      end
    end

    def long_name
      names = [self.name]
      this_parent = self.parent
      while this_parent do
        names << this_parent.name
        this_parent = this_parent.parent
      end
      names.reverse.join(":")
    end

    def type_string
      TYPE.key(self.type).to_s.capitalize
    end
  end
end
