module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end

module PiggyBank::Tax::Form::Adapter
  class Base
    def initialize
      @general = PiggyBank::Tax::Data::General.new
      @income = PiggyBank::Tax::Data::Income.new
    end

    def first_name
      @general.first_name
    end

    def names
      primary_name = [@general.first_name, @general.last_name].join " "
      if @general.spouse_first_name && @general.spouse_last_name
        spouse_name = [@general.spouse_first_name, @general.spouse_last_name].join " "
        return [primary_name, spouse_name].join ", "
      else
        return primary_name
      end
    end

    def ssn
      @general.ssn
    end
  end
end
