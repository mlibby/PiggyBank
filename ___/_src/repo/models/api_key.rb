module PiggyBank
  # primary_key :api_key_id
  # String :description, text: true, null: false
  # String :value, text: true, null: false
  # String :version, text: true, null: false
  class ApiKey < Sequel::Model(:api_key)
    plugin :validation_helpers

    def self.update_fields
      return [:description, :value]
    end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def validate
      super
      validates_presence :description
      validates_presence :value
    end
  end
end
