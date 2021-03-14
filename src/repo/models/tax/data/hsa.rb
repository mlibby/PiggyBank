require "singleton"
require "yaml"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Data; end

class PiggyBank::Tax::Data::HSA
  include Singleton

  FIELDS = [
    :covered_by_hdhp,
    :f5968sa_contributions,
    :f1099sa_distributions,
    :expenses_paid_by_hsa
  ]

  COVERAGE_TYPES = {
    none: "None",
    self: "Self-only",
    family: "Family"
  }

  def initialize
    @blob = PiggyBank::Blob.find(name: "2020-tax-hsa") ||
            PiggyBank::Blob.create(
              name: "2020-tax-hsa",
              yaml: "--- {}\n",
            )

    if @blob.yaml.nil?
      @values = {}
    else
      @values = YAML.load(@blob.yaml)
    end
  end

  FIELDS.each do |sym|
    define_method sym do
      @values[sym]
    end
  end

  def update(params)
    FIELDS.each do |sym|
      @values[sym] = params[sym.to_s]
    end
  end

  def save
    @blob.yaml = @values.to_yaml
    @blob.save
  end
end
