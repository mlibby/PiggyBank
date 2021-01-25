module PiggyBank
  #
  # primary_key :price_id
  # foreign_key :currency_id, :commodity, null: false, key: [:commodity_id]
  # foreign_key :commodity_id, :commodity, null: false, key: [:commodity_id]
  # String :quote_date, text: true, null: false
  # BigDecimal :value, null: false
  # String :version, text: true, null: false
  #
  class Price < Sequel::Model(:price)
    plugin :validation_helpers

    many_to_one :commodity, class: PiggyBank::Commodity
    many_to_one :currency, class: PiggyBank::Commodity, key: :commodity_id

    def self.update_fields
      return [:currency_id, :commodity_id, :quote_date, :value]
    end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def validate
      super
      # validates_presence :type
      # validates_presence :name
      # validates_presence :commodity_id
      # validates_presence :is_placeholder
    end

    def value_string
    end
  end
end
