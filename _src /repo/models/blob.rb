module PiggyBank
  #
  # primary_key :blob_id
  # String :name, text: true, null: false
  # String :yaml, text: true, null: false
  #
  class Blob < Sequel::Model(:blob)
    plugin :validation_helpers

    def validate
      super
      validates_presence :name
      validates_presence :yaml
    end
  end
end
