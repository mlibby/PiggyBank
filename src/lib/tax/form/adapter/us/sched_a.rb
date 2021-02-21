require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::ScheduleA < PiggyBank::Tax::Form::Adapter::Base
  def line_17
    BigDecimal("0.0")
  end

  def line_18
    false
  end
end
