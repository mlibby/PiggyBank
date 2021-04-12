require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Schedule1 < PiggyBank::Tax::Form::Adapter::Base
  def initialize
    super
    @schede = PiggyBank::Tax::Form::Adapter::US::ScheduleE.instance
  end

  def line_1
    refund = BigDecimal(unless @income.state_refund.nil? || @income.state_refund.empty? then @income.state_refund else "0" end)
    credits = BigDecimal(unless @income.other_credits.nil? || @income.other_credits.empty? then @income.other_credits else "0" end)
    refund + credits
  end

  def line_2
    BigDecimal("0.0")
  end

  def line_3
    BigDecimal("0.0")
  end

  def line_4
    BigDecimal("0.0")
  end

  def line_5
    @schede.line_26
  end

  def line_6
    BigDecimal("0.0")
  end

  def line_7
    BigDecimal("0.0")
  end

  def line_8
    BigDecimal("0.0")
  end

  def line_9
    [line_1, line_2, line_3, line_4, line_5, line_6, line_7, line_8].sum
  end
end
