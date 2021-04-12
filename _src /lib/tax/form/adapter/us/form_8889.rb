require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Form8889 < PiggyBank::Tax::Form::Adapter::Base
  def initialize
    super
    @hsa = PiggyBank::Tax::Data::HSA.instance
  end

  def covered_by_hdhp
    _d @hsa.covered_by_hdhp
  end

  def line_2
    _d("0")
  end

  def line_3
    #FUTURE: not going to bother with the actual logic for this right now
    _d("7100")
  end

  def line_4
    _d("0")
  end

  def line_5
    line_3 - line_4
  end

  def line_6
    line_5
  end

  def line_7
    _d("0")
  end

  def line_8
    line_6 + line_7
  end

  def line_9
    _d @hsa.f5968sa_contributions
  end

  def line_10
    _d "0" 
  end

  def line_11
    line_9 + line_10
  end

  def line_12
    amount = line_8 - line_11
    return amount < 0 ? _d("0.0") : amount
  end

  def line_13
    line_2 < line_12 ? line_2 : line_12
  end

  def line_14a
    _d @hsa.f1099sa_distributions
  end

  def line_14b
    _d("0")
  end

  def line_14c
    line_14a - line_14b
  end

  def line_15
    _d @hsa.expenses_paid_by_hsa
  end

  def line_16 
    line_14c - line_15
  end
end
