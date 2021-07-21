require "singleton"
require "yaml"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Data; end

class PiggyBank::Tax::Data::Education
  include Singleton

  FIELDS = [
    :student_name,
    :student_ssn,
    :institution_name,
    :institution_address,
    :institution_ein,
    :lifetime_credit_expenses,
    :m1529_name_1,
    :m1529_account_1,
    :m1529_amount_1,
    :m1529_name_2,
    :m1529_account_2,
    :m1529_amount_2,
  ]

  BUTTONS = [
    :received_1098,
    :box_7_checked,
    :hope_opportunity_claimed,
    :at_least_half_time,
    :postsecondary_completed,
  ]

  def initialize
    @blob = PiggyBank::Blob.find(name: "2020-tax-education") ||
            PiggyBank::Blob.create(
              name: "2020-tax-education",
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

  BUTTONS.each do |sym|
    define_method sym do
      @values[sym]
    end
  end

  def update(params)
    FIELDS.each do |sym|
      @values[sym] = params[sym.to_s]
    end

    BUTTONS.each do |sym|
      @values[sym] = !params[sym.to_s].nil?
    end
  end

  def save
    @blob.yaml = @values.to_yaml
    @blob.save
  end
end
