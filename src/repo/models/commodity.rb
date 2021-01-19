module PiggyBank
  class Commodity < Sequel::Model(:commodity)
    plugin :validation_helpers

    # primary_key :commodity_id
    # Integer :type, null: false
    # String :name, text: true, null: false
    # String :description, text: true, null: false
    # String :ticker, text: true
    # Integer :fraction, null: false
    # String :version, text: true, null: false
    def self.update_fields
      return [:type, :name, :description, :ticker, :fraction]
    end

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

    def fraction_opts
      opts = [
        { value: 1, text: "Whole Values (123)" },
        { value: 10, text: "1/10 (123.1)" },
        { value: 100, text: "1/100 (123.12)" },
        { value: 1000, text: "1/1,000 (123.123)" },
        { value: 10000, text: "1/10,000 (123.1234)" },
        { value: 100000, text: "1/100,000 (123.12345)" },
        { value: 1000000, text: "1/1,000,000 (123.123456)" },
      ]

      opts.each do |opt|
        opt[:selected] = opt[:value] == self.fraction
      end

      opts
    end

    def type_opts
      opts = COMMODITY_TYPE.map do |key, value|
        { value: value, text: key.capitalize, selected: value == self.type }
      end
    end
  end
end
