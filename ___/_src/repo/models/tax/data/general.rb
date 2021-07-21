require "singleton"
require "yaml"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Data; end

class PiggyBank::Tax::Data::Dependent
  attr_accessor :first_name, :last_name, :ssn, :relation, :child_credit, :other_credit

  def child_credit=(val)
    @child_credit = !val.nil?
  end

  def other_credit=(val)
    @other_credit = !val.nil?
  end

  def name
    [@first_name, @last_name].join " "
  end
end

class PiggyBank::Tax::Data::General
  include Singleton

  FIELDS = [
    :filing_status,
    :first_name, :last_name, :ssn,
    :birthday, :occupation,
    :spouse_first_name, :spouse_last_name, :spouse_ssn,
    :spouse_birthday, :spouse_occupation,
    :street, :apt_no,
    :city, :state, :zip,
    :country, :province, :post_code,
    :mn_campaign, :spouse_mn_campaign,
    :bank_type, :bank_routing, :bank_account,
    :contact_phone, :contact_email,
  ]

  BUTTONS = [
    :virtual,
    :blind, :spouse_blind,
    :campaign, :spouse_campaign,
  ]

  FILING_STATUSES = {
    single: "Single",
    joint: "Married Filing Jointly",
    separate: "Married Filing Separately",
    hoh: "Head of Household",
    widow: "Qualifying Widower",
  }

  MN_CAMPAIGN_OPTS = {
    "": "None",
    "11": "Republican",
    "12": "DFL",
    "13": "Independence",
    "14": "Grassroots",
    "15": "Green",
    "16": "Libertarian",
    "17": "Legal Marijuana",
    "99": "General Fund",
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
    d = PiggyBank::Tax::Data::Dependent.new
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
        d = PiggyBank::Tax::Data::Dependent.new
        d.first_name = dp["first_name"]
        d.last_name = dp["last_name"]
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
