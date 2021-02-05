require "yaml"

module PiggyBank
  module Tax
    class Form1098
      FIELDS = [
        :interest,
        :outstanding,
        :origination,
        :refund,
        :premiums,
        :points_paid,
        :same_address,
        :address,
        :properties,
        :other,
        :acquisition
      ]

      attr_accessor *FIELDS
    end

    class Deduct
      def initialize
        @blob = PiggyBank::Blob.find(name: "2020-tax-deduct") ||
                PiggyBank::Blob.create(
                  name: "2020-tax-deduct",
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

      def form1098s
        @values[:form1098s] || []
      end

      def add_1098
        w = Form1098.new
        @values[:form1098s] ||= []
        @values[:form1098s] << w
      end

      def rm_1098(index)
        @values[:form1098s].slice! index.to_i
      end

      def update(params)
        @values[:form1098s] = []
        if params.has_key? "form1098"
          params["form1098"].each do |pw|
            w = Form1098.new
            Form1098::FIELDS.each do |f|
              w.send("#{f}=", pw[f])
            end
            @values[:form1098s] << w
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
