require "bigdecimal"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end
module PiggyBank::Tax::Form::Adapter; end
module PiggyBank::Tax::Form::Adapter::US; end

class PiggyBank::Tax::Form::Adapter::US::Form1040
  def initialize
    @general = PiggyBank::Tax::Data::General.new
    @income = PiggyBank::Tax::Data::Income.new
  end

  def first_name
    @general.first_name
  end

  def last_name
    @general.last_name
  end

  def ssn
    format_ssn(@general.ssn)
  end

  def spouse_first_name
    @general.spouse_first_name
  end

  def spouse_last_name
    @general.spouse_last_name
  end

  def spouse_ssn
    format_ssn(@general.spouse_ssn)
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

  def dependents
    dstruct = Struct.new(:name, :ssn, :relation, :child_credit, :other_credit)
    deps = @general.dependents || []
    deps.map do |dep|
      dstruct.new dep.name,
        format_ssn(dep.ssn),
        dep.relation,
        dep.child_credit,
        dep.other_credit
    end
  end

  def single?
    @general.filing_status == "single"
  end

  def married_joint?
    @general.filing_status == "married"
  end

  def married_separately?
    @general.filing_status == "mfs"
  end

  def head_of_household?
    @general.filing_status == "hoh"
  end

  def qualified_widow?
    @general.filing_status == "qw"
  end

  def campaign?
    @general.campaign
  end

  def spouse_campaign?
    @general.spouse_campaign
  end

  def virtual_currency?
    @general.virtual
  end

  def born_before_19560102?
    !@general.birthday.nil? && @general.birthday < "1956-01-02"
  end

  def blind?
    @general.blind
  end

  def spouse_born_before_19560102?
    !@general.spouse_birthday.nil? && @general.spouse_birthday < "1956-01-02"
  end

  def spouse_blind?
    @general.spouse_blind
  end

  def more_than_four_deps?
    @general.dependents.size > 4
  end

  # Total Wages
  def line_1
    format_currency @income.w2s.sum { |w| BigDecimal(w.wages) }
  end

  private

  def format_currency(value)
    segments = []
    value.round.digits.each_slice(3) { |s| segments << s.join }
    curr = segments.join(",").reverse
    "#{curr}."
  end

  def format_ssn(ssn)
    return if ssn.nil? || ssn == ""
    ssn = ssn.tr "-", ""
    ssn.insert 3, " "
    ssn.insert 6, " "
  end
end
