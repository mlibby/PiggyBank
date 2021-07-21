require "singleton"
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

class PiggyBank::Tax::Data::CashDonation
  FIELDS = [
    :charity,
    :amount
  ]

  attr_accessor *FIELDS
end

class PiggyBank::Tax::Data::NonCashDonation
  FIELDS = [
    :charity,
    :address,
    :description,
    :date,
    :amount,
    :method
  ]

  attr_accessor *FIELDS
end



class PiggyBank::Tax::Data::Deduct
  include Singleton
  
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

  def cash_donations
    @values[:cash_donations] || []
  end

  def noncash_donations
    @values[:noncash_donations] || []
  end

  def add_1098
    w = PiggyBank::Tax::Data::Form1098.new
    @values[:form1098s] ||= []
    @values[:form1098s] << w
  end

  def add_cd
    w = PiggyBank::Tax::Data::CashDonation.new
    @values[:cash_donations] ||= []
    @values[:cash_donations] << w
  end

  def add_ncd
    w = PiggyBank::Tax::Data::NonCashDonation.new
    @values[:noncash_donations] ||= []
    @values[:noncash_donations] << w
  end

  def rm_1098(index)
    @values[:form1098s].slice! index.to_i
  end

  def rm_cd(index)
    @values[:cash_donations].slice! index.to_i
  end

  def rm_ncd(index)
    @values[:noncash_donations].slice! index.to_i
  end

  def update(params)
    FIELDS.each do |sym|
      @values[sym] = params[sym.to_s]
    end

    @values[:form1098s] = []
    if params.has_key? "form1098"
      params["form1098"].each do |pw|
        w = PiggyBank::Tax::Data::Form1098.new
        PiggyBank::Tax::Data::Form1098::FIELDS.each do |f|
          w.send("#{f}=", pw[f])
        end
        @values[:form1098s] << w
      end
    end

    @values[:cash_donations] = []
    if params.has_key? "cash_donation"
      params["cash_donation"].each do |cd|
        d = PiggyBank::Tax::Data::CashDonation.new
        PiggyBank::Tax::Data::CashDonation::FIELDS.each do |f|
          d.send("#{f}=", cd[f])
        end
        @values[:cash_donations] << d
      end
    end

    @values[:noncash_donations] = []
    if params.has_key? "noncash_donation"
      params["noncash_donation"].each do |nd|
        d = PiggyBank::Tax::Data::NonCashDonation.new
        PiggyBank::Tax::Data::NonCashDonation::FIELDS.each do |f|
          d.send("#{f}=", nd[f])
        end
        @values[:noncash_donations] << d
      end
    end
  end

  def save
    @blob.yaml = @values.to_yaml
    @blob.save
  end
end
