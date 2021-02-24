require "yaml"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Data; end

class PiggyBank::Tax::Data::Form1098
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
    :acquisition,
  ]

  attr_accessor *FIELDS
end

class PiggyBank::Tax::Data::Deduct
  FIELDS = [
    :real_estate_tax,
    :property_tax
  ]

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

  FIELDS.each do |sym|
    define_method sym do
      @values[sym]
    end
  end

  def form1098s
    @values[:form1098s] || []
  end

  def add_1098
    w = PiggyBank::Tax::Data::Form1098.new
    @values[:form1098s] ||= []
    @values[:form1098s] << w
  end

  def rm_1098(index)
    @values[:form1098s].slice! index.to_i
  end

  def update(params)
    FIELDS.each do |sym|
      @values[sym] = params[sym.to_s]
    end

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
