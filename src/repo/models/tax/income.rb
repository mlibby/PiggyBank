require "bigdecimal"
require "yaml"

module PiggyBank
  module Tax
    class W2
      FIELDS = [
        :ssn, :ein, :employer,
        :wages, :fed_wh,
        :soc_sec_wages, :soc_sec_wh,
        :medicare_wages, :medicare_taxes,
        :soc_sec_tips, :allocated_tips,
        :box_9, :dep_care_benefits,
        :nonqual_plans,
        :code_12a, :box_12a,
        :code_12b, :box_12b,
        :code_12c, :box_12c,
        :code_12d, :box_12d,
        :statutory_employee,
        :retirement_plan,
        :sick_pay,
        :other,
        :state, :state_ein,
        :state_wages,
        :state_tax,
        :local_wages,
        :local_tax,
        :locality,
      ]

      attr_accessor *FIELDS

      def statutory_employee=(val)
        @statutory_employee = !val.nil?
      end

      def retirement_plan=(val)
        @retirement_plan = !val.nil?
      end

      def sick_pay=(val)
        @sick_pay = !val.nil?
      end
    end

    class Income
      def initialize
        @blob = PiggyBank::Blob.find(name: "2020-tax-income") ||
                PiggyBank::Blob.create(
                  name: "2020-tax-income",
                  yaml: "--- {}\n",
                )

        if @blob.yaml.nil?
          @values = {
            w2s: [],
          }
        else
          @values = YAML.load(@blob.yaml)
        end
      end

      def w2s
        @values[:w2s] || []
      end

      def add_w2
        w = W2.new
        @values[:w2s] ||= []
        @values[:w2s] << w
      end

      def rm_w2(index)
        @values[:w2s].slice! index.to_i
      end

      def update(params)
        @values[:w2s] = []
        if params.has_key? "w2"
          params["w2"].each do |pw|
            w = W2.new
            W2::FIELDS.each do |f|
              w.send("#{f}=", pw[f])
            end
            @values[:w2s] << w
          end
        end
      end

      def save
        @blob.yaml = @values.to_yaml
        @blob.save
      end

      def total_wages
        w2s.sum{|w| BigDecimal(w.wages) }
      end
    end
  end
end
