module PiggyBank

  class ApiKey < Sequel::Model(:api_key)
    plugin :validation_helpers

    # one_to_many :splits, class: PiggyBank::Split

    # def self.update_fields
    #   return [:post_date, :number, :description]
    # end

    # def before_create
    #   self.version = PiggyBank::Repo.timestamp
    # end

    # def validate
    #   super
    #   validates_presence :post_date
    #   validates_presence :description
    # end
  end
end
