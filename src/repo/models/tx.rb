module PiggyBank
  #
  # primary_key :tx_id
  # String :post_date, text: true, null: false
  # String :number, text: true
  # String :description, text: true, null: false
  # String :version, text: true, null: false
  #
  class Tx < Sequel::Model(:tx)
    plugin :validation_helpers

    # many_to_one :commodity, class: PiggyBank::Commodity

    # def self.update_fields
    #   return [:post_date, :number, :description]
    # end

    # def before_create
    #   self.version = PiggyBank::Repo.timestamp
    # end

    # def validate
    #   super
    # end
  end
end
