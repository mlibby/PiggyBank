require "yaml"

module PiggyBank
  module Tax
    class W2
      FIELDS = [
        :wages,
        :fed_wh,
        :soc_sec_wages,
        :soc_sec_wh,
        :medicare_wages,
        :medicare_taxes,
        :soc_sec_tips,
        :allocated_tips,
        :box_9,
        :dep_care_benefits,
        :nonqual_plans,
        :box_12a,
        :box_12b,
        :box_12c,
        :box_12d,
        :statutory_employee,
        :retirement_plan,
        :sick_pay,
        :other,
        :state,
        :state_wages,
        :state_tax,
        :local_wages,
        :local_tax,
        :locality,
      ]

      attr_accessor *FIELDS
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
        @values[:w2s] || [W2.new]
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
    end
  end
end
