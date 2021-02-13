require "yaml"

module PiggyBank
  module Tax
    class Dependent
      attr_accessor :name, :ssn, :relation, :child_credit, :other_credit

      def child_credit=(val)
        @child_credit = !val.nil?
      end

      def other_credit=(val)
        @other_credit = !val.nil?
      end
    end

    class General
      FIELDS = [
        :filing_status,
        :first_name, :last_name, :ssn,
        :birthday,
        :spouse_first_name, :spouse_last_name, :spouse_ssn,
        :spouse_birthday,
        :street, :apt_no,
        :city, :state, :zip,
        :country, :province, :post_code,
      ]

      BUTTONS = [
        :virtual, 
        :blind, :spouse_blind,
        :campaign, :spouse_campaign
      ]

      FILING_STATUSES = {
        single: "Single",
        married: "Married Filing Jointly",
        mfs: "Married Filing Separately",
        hoh: "Head of Household",
        qw: "Qualifying Widower"
      }

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
      end

      BUTTONS.each do |sym|
        define_method sym do
          @values[sym]
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

        BUTTONS.each do |sym|
          @values[sym] = !params[sym.to_s].nil?
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

      def names
        primary_name = [ @values[:first_name], @values[:last_name] ].join " "
        if @values[:spouse_first_name] && @values[:spouse_last_name]
          spouse_name = [@values[:spouse_first_name], @values[:spouse_last_name]].join " "
          return [primary_name, spouse_name].join ", "
        else
          return primary_name
        end
      end
    end
  end
end
