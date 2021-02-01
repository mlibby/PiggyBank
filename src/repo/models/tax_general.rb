require "yaml"

module PiggyBank
  module Tax
    class Dependent
      attr_accessor :name, :ssn, :relation, :child_credit, :other_credit
    end

    class General
      FIELDS = [
        :first_name, :last_name, :ssn,
        :birthday, :blind,
        :spouse_first_name, :spouse_last_name, :spouse_ssn,
        :spouse_birthday, :spouse_blind,
        :street, :apt_no,
        :city, :state, :zip,
        :country, :province, :post_code,
      ]

      def initialize
        @blob = PiggyBank::Blob.find(name: "2020-tax-general") ||
                PiggyBank::Blob.create(
                  name: "2020-tax-general",
                  yaml: "--- {}\n",
                )

        if @blob.yaml.nil?
          @values = {
            dependents: [],
          }
        else
          @values = YAML.load(@blob.yaml)
        end
      end

      FIELDS.each do |sym|
        define_method sym do
          @values[sym]
        end

        define_method "#{sym.to_s}=" do |value|
          @values[sym] = value
        end
      end

      def dependents
        @values[:dependents] || []
      end

      def add_dependent
        d = Dependent.new
        @values[:dependents] ||= []
        @values[:dependents] << d
      end

      def rm_dependent(index)
        @values[:dependents].slice! index.to_i
      end

      def update(params)
        FIELDS.each do |sym|
          @values[sym] = params[sym.to_s]
        end

        @values[:dependents] = []
        if params.has_key? "dependents"
          params["dependents"].each do |dp|
            d = Dependent.new
            d.name = dp["name"]
            d.ssn = dp["ssn"]
            d.relation = dp["relation"]
            d.child_credit = dp["child_credit"]
            d.other_credit = dp["other_credit"]
            @values[:dependents] << d
          end
        end
      end

      def save
        @blob.yaml = @values.to_yaml
        @blob.save
      end
    end
  end
end
