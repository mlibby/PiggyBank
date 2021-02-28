require_relative "../base"

class PiggyBank::Tax::Form::Adapter::US::Form8863 < PiggyBank::Tax::Form::Adapter::Base
  def initialize
    super
    @ssn_parts = @general.ssn.split("-")
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

end
