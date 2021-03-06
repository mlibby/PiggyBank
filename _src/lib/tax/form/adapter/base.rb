require_relative "../../../under_decimal"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end

module PiggyBank::Tax::Form::Adapter
  class Base
    def initialize
      @general = PiggyBank::Tax::Data::General.instance
      @income = PiggyBank::Tax::Data::Income.instance
      @deduct = PiggyBank::Tax::Data::Deduct.instance
      @education = PiggyBank::Tax::Data::Education.instance
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

    def first_name
      @general.first_name
    end

    def last_name
      @general.last_name
    end

    def ssn
      @general.ssn
    end

    def birthday
      @general.birthday
    end

    def spouse_first_name
      @general.spouse_first_name
    end

    def spouse_last_name
      @general.spouse_last_name
    end

    def spouse_ssn
      @general.spouse_ssn
    end

    def spouse_birthday
      @general.spouse_birthday
    end

    def address
      [@general.street, @general.apt_no].join ", "
    end

    def street
      @general.street
    end

    def apt_no
      @general.apt_no
    end

    def city
      @general.city
    end

    def state
      @general.state
    end

    def zip
      @general.zip
    end

    def country
      @general.country
    end

    def province
      @general.province
    end

    def post_code
      @general.post_code
    end

    def filing_status
      @general.filing_status.to_sym
    end

    def single?
      @general.filing_status == "single"
    end

    def married_joint?
      @general.filing_status == "joint"
    end

    def married_separately?
      @general.filing_status == "separate"
    end

    def head_of_household?
      @general.filing_status == "hoh"
    end

    def qualified_widow?
      @general.filing_status == "widow"
    end

    def contact_phone
      @general.contact_phone
    end

    def contact_email
      @general.contact_email
    end
  end
end
