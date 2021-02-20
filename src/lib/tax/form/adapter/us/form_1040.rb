require_relative "../base.rb"

module PiggyBank::Tax::Form::Adapter::US
  class Form1040 < PiggyBank::Tax::Form::Adapter::Base
    def initialize
      super
      @sched1 = PiggyBank::Tax::Form::Adapter::US::Schedule1.new
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
