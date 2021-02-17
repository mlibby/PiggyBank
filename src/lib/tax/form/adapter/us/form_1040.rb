require_relative "../base.rb"

module PiggyBank::Tax::Form::Adapter::US
  class Form1040 < PiggyBank::Tax::Form::Adapter::Base
    def initialize
      super
      @sched1 = PiggyBank::Tax::Form::Adapter::US::Schedule1.new
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

    def spouse_first_name
      @general.spouse_first_name
    end

    def spouse_last_name
      @general.spouse_last_name
    end

    def spouse_ssn
      @general.spouse_ssn
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
      dependent = Struct.new(:name, :ssn, :relation, :child_credit, :other_credit)
      @general.dependents.map do |dep|
        dependent.new dep.name,
          dep.ssn,
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
      @income.w2s.sum { |w| BigDecimal(w.wages) }
    end

    def line_8
      @sched1.line_9
    end
  end
end