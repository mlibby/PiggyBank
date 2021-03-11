require "singleton"
require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Form8863 < PiggyBank::Tax::Form::Adapter::Base
  include Singleton

  attr_accessor :us_1040, :us_sched3

  def initialize
    super
    @ssn_parts = @general.ssn.split("-")
    @student_ssn_parts = @education.student_ssn.split("-")
  end

  def ssn_part_one
    @ssn_parts[0]
  end

  def ssn_part_two
    @ssn_parts[1]
  end

  def ssn_part_three
    @ssn_parts[2]
  end

  def institution_ein
    @education.institution_ein
  end

  def line_1
    _d("0")
  end

  def line_7
    _d("0")
  end

  def line_8
    _d("0")
  end

  def line_9
    _d("0")
  end

  def line_10
    line_31
  end

  def line_11
    line_10 < 10000 ? line_10 : _d("10000")
  end

  def line_12
    line_11 * 0.20
  end

  def line_13
    married_joint? ? _d("138000") : _d("69000")
  end

  def line_14
    @us_1040.line_11
  end

  def line_15
    amount = line_13 - line_14
  end

  def line_16
    if line_15 > 0
      if married_joint?
        return _d("20000")
      else
        return _d("10000")
      end
    end
    _d("0.0")
  end

  def ratio
    if line_15 >= line_16
      return _d("1.000")
    else
      (line_15 / line_16).round(3)
    end
  end

  def line_17_integer
    return "" unless line_15 > 0
    return ratio.floor.to_s
  end

  def line_17_fractional
    return "" unless line_15 > 0
    if line_15 >= line_16
      return "000"
    else
      return (ratio.frac * 1000).to_i.to_s
    end
  end

  def line_18
    return _d("0.0") unless line_15 > 0
    line_12 * ratio
  end

  def line_19
    # aka "Credit Limit Worksheet"
    amounts = line_18 + line_9
    tax = @us_1040.line_18
    credits = @us_sched3.line_1 + @us_sched3.line_2
    diff = tax - credits
    amounts < diff ? amounts : diff
  end

  def line_20
    @education.student_name
  end

  def line_21a
    @student_ssn_parts[0]
  end

  def line_21b
    @student_ssn_parts[1]
  end

  def line_21c
    @student_ssn_parts[2]
  end

  def line_22a
    @education.institution_name
  end

  def line_22a1
    @education.institution_address
  end

  def line_22a2
    @education.received_1098
  end

  def line_22a3
    @education.box_7_checked
  end

  def line_23
    @education.hope_opportunity_claimed
  end

  def line_24
    @education.at_least_half_time
  end

  def line_25
    @education.postsecondary_completed
  end

  def line_31
    _d(@education.lifetime_credit_expenses)
  end
end
