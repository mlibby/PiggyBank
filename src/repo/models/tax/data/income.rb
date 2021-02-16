require "bigdecimal"
require "yaml"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Data; end

class PiggyBank::Tax::Data::Income
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

    @values[:rentals] = []
    if params.has_key? "rentals"
      params["rentals"].each do |rental|
        r = PiggyBank::Tax::Data::Rental.new
        PiggyBank::Tax::Data::Rental::FIELDS.each do |f|
          r.send("#{f}=", pw[f])
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
