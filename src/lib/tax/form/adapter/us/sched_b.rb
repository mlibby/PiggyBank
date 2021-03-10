require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::ScheduleB < PiggyBank::Tax::Form::Adapter::Base
  def line_1_payer_1
    @income.f1099_ints[0].payer
  end

  def line_1_amount_1
    _d(@income.f1099_ints[0].paid)
  end

  def line_2
    @income.f1099_ints.sum { |f| _d(f.paid) }
  end

  def line_3
    _d("0")
  end

  def line_4
    line_2 - line_3
  end
end
