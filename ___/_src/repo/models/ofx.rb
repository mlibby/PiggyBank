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

    many_to_one :account, class: PiggyBank::Account

    def self.update_fields
      return [
        :active, :account_id, :url, 
        :user, :password, 
        :fid, :fid_org, 
        :bank_id, :bank_account_id,
        :account_type
      ]
    end

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def validate
      super
      validates_presence :url
      validates_presence :user
      validates_presence :fid
      validates_presence :fid_org
      validates_presence :bank_id
      validates_presence :bank_account_id
      validates_presence :account_type
    end
  end
end
