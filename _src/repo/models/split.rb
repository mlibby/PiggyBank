module PiggyBank
  #
  # primary_key :split_id
  # foreign_key :tx_id, :tx, null: false, key: [:tx_id]
  # foreign_key :account_id, :account, null: false, key: [:account_id]
  # String :memo, text: true
  # BigDecimal :amount, null: false
  # BigDecimal :value, null: false
  # String :version, text: true, null: false
  #
  class Split < Sequel::Model(:split)
    plugin :validation_helpers

    many_to_one :tx, class: "PiggyBank::Tx"
    many_to_one :account, class: "PiggyBank::Account"

    def self.update_fields
      return [:tx_id, :account_id, :memo, :amount, :value]
    end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def validate
      validates_presence :tx_id
      validates_presence :account_id
      validates_presence :amount
      validates_presence :value
    end
  end
end

# ZZZ: remove commodity -- it's inherent to account
