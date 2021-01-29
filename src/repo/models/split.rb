module PiggyBank
  class Tx < Sequel::Model(:tx)
    #needed because we define a relationship
  end

  #
  # primary_key :split_id
  # foreign_key :tx_id, :tx, null: false, key: [:tx_id]
  # foreign_key :account_id, :account, null: false, key: [:account_id]
  # TODO: remove commodity -- it's inherent to account
  # foreign_key :commodity_id, :commodity, null: false, key: [:commodity_id]
  # String :memo, text: true
  # BigDecimal :amount, null: false
  # BigDecimal :value, null: false
  # String :version, text: true, null: false
  #
  class Split < Sequel::Model(:split)
    plugin :validation_helpers

    many_to_one :tx, class: PiggyBank::Tx
    many_to_one :account, class: PiggyBank::Account

    # def self.update_fields
    #   return [:memo, :amount, :value]
    # end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    # def validate
    #   super
    # end
  end
end
