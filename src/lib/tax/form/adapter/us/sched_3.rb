require "singleton"
require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Schedule3 < PiggyBank::Tax::Form::Adapter::Base
  include Singleton

  attr_accessor :us_8863

  def line_1
    _d("0.0")
  end

  def line_2
    _d("0.0")
  end

  def line_3
    @us_8863.line_19
  end

  def line_7
    [line_1, line_2, line_3].sum
  end

  def line_13
    _d("0.0")
  end
end
