module PiggyBank
  class Setting < Sequel::Model(:setting)
    plugin :validation_helpers

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def before_update
      existing = PiggyBank::Setting.find(setting_id: self.setting_id, version: self.version)
      raise Sequel::ValidationFailed unless existing
    end

    def validate
      super
      validates_presence :name
      validates_presence :value
    end
  end
end
