require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::ScheduleA < PiggyBank::Tax::Form::Adapter::Base
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

  def line_17
    _d
  end

  def line_18
    false
  end
end
