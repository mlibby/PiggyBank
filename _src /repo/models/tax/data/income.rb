require "bigdecimal"
require "singleton"
require "yaml"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Data; end

class PiggyBank::Tax::Data::Income
  include Singleton

  FIELDS = [
    :state_refund,
    :other_credits
  ]

  FIELDS.each do |sym|
    define_method sym do
      @values[sym]
    end
  end

  def initialize
    @blob = PiggyBank::Blob.find(name: "2020-tax-income") ||
            PiggyBank::Blob.create(
              name: "2020-tax-income",
              yaml: "--- {}\n",
            )

    if @blob.yaml.nil?
      @values = {
        w2s: [],
        rentals: [],
        f1099ints: [],
        f1099divs: [],
      }
    else
      @values = YAML.load(@blob.yaml)
    end
  end

  def rentals
    @values[:rentals] || []
  end

  def add_rental
    r = PiggyBank::Tax::Data::Rental.new
    @values[:rentals] ||= []
    @values[:rentals] << r
  end

  def rm_rental(index)
    @values[:rentals].slice! index.to_i
  end

  def w2s
    @values[:w2s] || []
  end

  def add_w2
    w = PiggyBank::Tax::Data::W2.new
    @values[:w2s] ||= []
    @values[:w2s] << w
  end

  def rm_w2(index)
    @values[:w2s].slice! index.to_i
  end

  def f1099_ints
    @values[:f1099_ints] || []
  end

  def add_f1099_int
    w = PiggyBank::Tax::Data::Form1099.new
    @values[:f1099_ints] ||= []
    @values[:f1099_ints] << w
  end

  def rm_f1099_int(index)
    @values[:f1099_ints].slice! index.to_i
  end

  def f1099_divs
    @values[:f1099_divs] || []
  end

  def add_f1099_div
    w = PiggyBank::Tax::Data::Form1099Div.new
    @values[:f1099_divs] ||= []
    @values[:f1099_divs] << w
  end

  def rm_f1099_div(index)
    @values[:f1099_divs].slice! index.to_i
  end

  def update(params)
    FIELDS.each do |sym|
      @values[sym] = params[sym.to_s]
    end
    
    @values[:w2s] = []
    if params.has_key? "w2"
      params["w2"].each do |pw|
        w = PiggyBank::Tax::Data::W2.new
        PiggyBank::Tax::Data::W2::FIELDS.each do |f|
          w.send("#{f}=", pw[f])
        end
        @values[:w2s] << w
      end
    end

    @values[:f1099_ints] = []
    if params.has_key? "f1099_int"
      params["f1099_int"].each do |pw|
        w = PiggyBank::Tax::Data::Form1099Int.new
        PiggyBank::Tax::Data::Form1099Int::FIELDS.each do |f|
          w.send("#{f}=", pw[f])
        end
        @values[:f1099_ints] << w
      end
    end

    @values[:f1099_divs] = []
    if params.has_key? "f1099_div"
      params["f1099_div"].each do |pw|
        w = PiggyBank::Tax::Data::Form1099Div.new
        PiggyBank::Tax::Data::Form1099Div::FIELDS.each do |f|
          w.send("#{f}=", pw[f])
        end
        @values[:f1099_divs] << w
      end
    end

    @values[:rentals] = []
    if params.has_key? "rental"
      params["rental"].each do |rental|
        r = PiggyBank::Tax::Data::Rental.new
        PiggyBank::Tax::Data::Rental::FIELDS.each do |f|
          r.send("#{f}=", rental[f])
        end
        @values[:rentals] << r
      end
    end
  end

  def save
    @blob.yaml = @values.to_yaml
    @blob.save
  end

end
