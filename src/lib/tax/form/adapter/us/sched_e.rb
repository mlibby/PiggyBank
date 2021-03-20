require "singleton"
require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::ScheduleE < PiggyBank::Tax::Form::Adapter::Base
  include Singleton

  attr_accessor :us_6198, :us_8582

  def line_1a_A
    @income.rentals[0]&.physical_address
  end

  def line_1b_type_A
    @income.rentals[0]&.property_type
  end

  def line_1b_rental_days_A
    @income.rentals[0]&.fair_rental_days
  end

  def line_1b_personal_days_A
    @income.rentals[0]&.personal_days
  end

  def line_1b_qjv_A
    @income.rentals[0]&.qualified_joint_venture
  end

  def line_3A
    _d(@income.rentals[0]&.rents_received)
  end

  def line_4A
    _d(@income.rentals[0]&.royalties_received)
  end

  def line_11A
    _d(@income.rentals[0]&.management_fees)
  end

  def line_16A
    _d(@income.rentals[0]&.taxes)
  end

  def line_20A
    [line_11A, line_16A].sum
  end

  def line_21A
    [line_3A, line_4A].sum - line_20A
  end

  def line_22A
    @us_8582.line_16
  end

  def line_23a
    [line_3A].sum
  end

  def line_23e
    [line_20A].sum
  end

  def line_24
    [line_21A].filter { |n| n > 0 }.sum
  end

  def line_25
    line_22A
  end

  def line_26
    line_24 - line_25
  end
end
