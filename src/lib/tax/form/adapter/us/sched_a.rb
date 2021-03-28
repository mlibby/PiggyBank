require "singleton"
require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::ScheduleA < PiggyBank::Tax::Form::Adapter::Base
  include Singleton

  def line_4
    _d
  end

  def line_5a
    @income.w2s.sum { |w| _d(w.state_tax) + _d(w.local_tax) }
  end

  def line_5b
    _d(@deduct.real_estate_tax)
  end

  def line_5c
    _d(@deduct.property_tax)
  end

  def line_5d
    [line_5a, line_5b, line_5c].sum
  end

  def line_5e
    limit = married_separately? ? _d("5000") : _d("10000")
    line_5d < limit ? line_5d : limit
  end

  def line_6
    #FUTURE: track other deductible taxes
    _d
  end

  def line_7
    line_5e + line_6
  end

  def line_8a
    @deduct.form1098s.sum { |f| _d(f.interest) }
  end

  def line_8b
    _d
  end

  def line_8c
    _d
  end

  def line_8d
    _d
  end

  def line_8e
    [line_8a, line_8b, line_8c, line_8d].sum
  end

  def line_9
    _d
  end

  def line_10
    line_8e + line_9
  end

  def line_11
    @deduct.cash_donations.sum { |d| _d(d.amount) }
  end

  def line_12
    @deduct.noncash_donations.sum { |d| _d(d.amount) }
  end

  def line_13
    _d
  end

  def line_14
    [line_11, line_12, line_13].sum
  end

  def line_15
    _d
  end

  def line_16
    _d
  end

  def line_17
    [line_4, line_7, line_10, line_14, line_15, line_16].sum
  end

  def line_18
    false
  end
end
