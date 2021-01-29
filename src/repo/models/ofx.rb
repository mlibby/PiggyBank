module PiggyBank
  # primary_key :ofx_id
  # TrueClass :active, default: false, null: false
  # foreign_key :account_id, :account, null: false, key: [:account_id]
  # String :url, default: "", text: true, null: false
  # String :user, default: "", text: true, null: false
  # String :password, default: "", text: true, null: false
  # Integer :fid, null: false
  # String :fid_org, text: true, null: false
  # String :bank_id, default: "", text: true, null: false
  # String :bank_account_id, text: true, null: false
  # String :account_type, text: true, null: false
  # String :version, text: true, null: false
  class Ofx < Sequel::Model(:ofx)
    plugin :validation_helpers

    # def self.update_fields
    #   return [:description, :value]
    # end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def validate
      super
      # validates_presence :description
      # validates_presence :value
    end
  end
end
