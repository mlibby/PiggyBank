require "singleton"
require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Form8582 < PiggyBank::Tax::Form::Adapter::Base
  include Singleton

  attr_accessor :us_6198, :us_schede

  def line_3a
    worksheet_3_total_a
  end

  def line_3b
    worksheet_3_total_b
  end

  def line_3c
    _d "0"
  end

  def line_3d
    [line_3a, line_3b, line_3c].sum
  end

  def line_4
    line_3d
  end

  def line_15
    line_3a
  end

  def line_16
    line_15
  end

  def worksheet_3_line_1_name
    @income.rentals[0]&.description
  end

  def worksheet_3_line_1a
    @us_schede.line_21A > 0 ? @us_schede.line_21A : _d("0")
  end

  def worksheet_3_line_1b
    @us_schede.line_21A < 0 ? @us_schede.line_21A : _d("0")
  end

  def worksheet_3_line_1d
    @us_schede.line_21A > 0 ? @us_schede.line_21A : _d("0")
  end

  def worksheet_3_line_1e
    @us_schede.line_21A < 0 ? @us_schede.line_21A : _d("0")
  end

  def worksheet_3_total_a
    worksheet_3_line_1a
  end

  def worksheet_3_total_b
    worksheet_3_line_1b
  end
end
