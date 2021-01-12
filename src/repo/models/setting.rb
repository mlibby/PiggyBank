module PiggyBank
  class Setting < Sequel::Model(:setting)
    plugin :validation_helpers

    def before_create
      self.version = PiggyBank::Repo.timestamp
    end

    def validate
      super
      validates_presence :name
      validates_presence :value
    end
  end
end
