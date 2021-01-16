module PiggyBank
  class Commodity < Sequel::Model(:commodity)
    plugin :validation_helpers

    COMMODITY_TYPE = {
      currency: 1,
      investment: 2,
    }

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def before_update
      existing = PiggyBank::Commodity.find(commodity_id: self.commodity_id, version: self.version)
      raise Sequel::ValidationFailed unless existing
    end

    # Integer :type, null: false
    # String :name, text: true, null: false
    # String :description, text: true, null: false
    # String :ticker, text: true
    # Integer :fraction, null: false
    # String :version, text: true, null: false

    def validate
      super
      validates_presence :type
      validates_presence :name
      validates_presence :description
      validates_presence :fraction
    end

    def type_string
      COMMODITY_TYPE.key(self.type).to_s.capitalize
    end
  end
end
