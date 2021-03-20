require "singleton"
require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Form6198 < PiggyBank::Tax::Form::Adapter::Base
  include Singleton

  attr_accessor :us_schede

  def description
    @income.rentals[0]&.description
  end

  def line_1
    @us_schede.line_21A
  end

  def line_5
    line_1
  end

  def line_11
    _d "0"
  end

  def line_13
    line_11
  end

  def line_14
    _d "0"
  end

  def line_15
    line_13
  end

  def line_15a
    true
  end

  def line_17
    line_15
  end

  def line_19a
    line_17
  end

  def line_19b
    line_19a
  end

  def line_20
    line_19a
  end

  def line_21
    line_5.abs > line_20 ? line_20 : line_5.abs
  end
end
