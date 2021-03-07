require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Schedule3 < PiggyBank::Tax::Form::Adapter::Base
  def line_1
    _d("0.0")
  end

  def line_2
    _d("0.0")
  end
  
  def line_7
    _d("0.0")
  end

  def line_13
    _d("0.0")
  end
end
