require "yaml"

module PiggyBank
  module Tax
    class General
      def initialize
        @blob = PiggyBank::Blob.find(name: "2020-tax-general") ||
                PiggyBank::Blob.create(name: "2020-tax-general", yaml: "--- {}\n")

        @values = @blob.yaml.nil? ? {} : YAML.load(@blob.yaml)
      end

      [
        :first_name, :last_name, :ssn,
        :spouse_first_name, :spouse_last_name, :spouse_ssn
      ].each do |sym|
        define_method sym do
          @values[sym] 
        end

        define_method "#{sym.to_s}=" do |value|
          @values[sym] = value
        end
      end

      def save
        @blob.yaml = @values.to_yaml
      end
    end
  end
end
