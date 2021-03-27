require "singleton"
require_relative "../base.rb"

module PiggyBank::Tax::Form::Adapter::US
  class Form1040 < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    attr_accessor :us_sched3

    def initialize
      super
      @sched1 = PiggyBank::Tax::Form::Adapter::US::Schedule1.new
      @scheda = PiggyBank::Tax::Form::Adapter::US::ScheduleA.new
      @schedb = PiggyBank::Tax::Form::Adapter::US::ScheduleB.new
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

    def occupation
      @general.occupation
    end

    def spouse_occupation
      @general.spouse_occupation
    end

    def contact_phone
      @general.contact_phone
    end

    def contact_email
      @general.contact_email
    end

    # Total Wages
    def line_1
      @income.w2s.sum { |w| _d(w.wages) }
    end

    def line_2b
      @schedb.line_4
    end

    def line_3a
      @income.f1099_divs.sum { |d| _d(d.qualified_dividends) }
    end

    def line_3b
      @schedb.line_6
    end

    def line_4b
      _d("0.0")
    end

    def line_5b
      _d("0.0")
    end

    def line_6b
      _d("0.0")
    end

    def line_7
      _d("0.0")
    end

    def line_8
      @sched1.line_9
    end

    def line_9
      [line_1, line_2b, line_3b, line_4b, line_5b, line_6b, line_7, line_8].sum
    end

    def line_10c
      _d("0.0")
    end

    def line_11
      line_9 - line_10c
    end

    STANDARD_DEDUCTIONS = {
      single: _d("12400.0"),
      joint: _d("24800.0"),
      separate: _d("12400.0"),
      hoh: _d("18650.0"),
      widow: _d("24800.0"),
    }

    # Standard or Itemized Deduction
    def line_12
      # use itemized even if less than standard
      return @scheda.line_17 if @scheda.line_18
      standard = STANDARD_DEDUCTIONS[filing_status]
      itemized = @scheda.line_17
      standard >= itemized ? standard : itemized
    end

    def line_13
      _d("0.0")
    end

    def line_14
      [line_12, line_13].sum
    end

    def line_15
      line_11 - line_14
    end

    bracket = Struct.new(:max, :rate)
    TAX_BRACKETS = {
      single: [
        bracket.new(_d("9875.00"), _d("0.1")),
        bracket.new(_d("40125.00"), _d("0.12")),
        bracket.new(_d("85525.00"), _d("0.22")),
        bracket.new(_d("163300.00"), _d("0.24")),
        bracket.new(_d("207350.00"), _d("0.32")),
        bracket.new(_d("518400.00"), _d("0.35")),
        bracket.new(_d("Infinity"), _d("0.37")),
      ],
      joint: [
        bracket.new(_d("19750.00"), _d("0.10")),
        bracket.new(_d("80250.00"), _d("0.12")),
        bracket.new(_d("171050.00"), _d("0.22")),
        bracket.new(_d("326600.00"), _d("0.24")),
        bracket.new(_d("414700.00"), _d("0.32")),
        bracket.new(_d("622050.00"), _d("0.35")),
        bracket.new(_d("Infinity"), _d("0.37")),
      ],
      separate: [
        bracket.new(_d("9875.00"), _d("0.10")),
        bracket.new(_d("40125.00"), _d("0.12")),
        bracket.new(_d("85525.00"), _d("0.22")),
        bracket.new(_d("163300.00"), _d("0.24")),
        bracket.new(_d("207350.00"), _d("0.32")),
        bracket.new(_d("311025.00"), _d("0.35")),
        bracket.new(_d("Infinity"), _d("0.37")),
      ],
      hoh: [
        bracket.new(_d("14100.00"), _d("0.10")),
        bracket.new(_d("53700.00"), _d("0.12")),
        bracket.new(_d("85500.00"), _d("0.22")),
        bracket.new(_d("163300.00"), _d("0.24")),
        bracket.new(_d("207350.00"), _d("0.32")),
        bracket.new(_d("518400.00"), _d("0.35")),
        bracket.new(_d("Infinity"), _d("0.37")),
      ],
      widow: [
        bracket.new(_d("19750.00"), _d("0.10")),
        bracket.new(_d("80250.00"), _d("0.12")),
        bracket.new(_d("171050.00"), _d("0.22")),
        bracket.new(_d("326600.00"), _d("0.24")),
        bracket.new(_d("414700.00"), _d("0.32")),
        bracket.new(_d("622050.00"), _d("0.35")),
        bracket.new(_d("Infinity"), _d("0.37")),
      ],
    }

    def calculate_tax(income, filing_status)
      tax = _d("0.0")
      min = _d("0.0")
      TAX_BRACKETS[filing_status].each do |bracket|
        if income >= bracket.max
          tax += (bracket.max - min) * bracket.rate
          min = bracket.max
        else
          tax += (income - min) * bracket.rate
          break
        end
      end
      tax
    end

    def get_tax_amount(income, filing_status)
      # this algorithm was adapted from Open Tax Solver's TaxRateFunction
      # https://sourceforge.net/p/opentaxsolver/SrcCodeRepo/HEAD/tree/trunk/OTS_2020/src/taxsolve_US_1040_2020.c
      if income < _d("100000.0")
        spread = if income < _d("25.0")
            _d("5.0")
          elsif income < _d("3000.0")
            _d("25.0")
          else
            _d("50.0")
          end

        half_spread = spread * _d("0.5")
        reduced_income = (income / spread).truncate
        modified_income = spread * reduced_income + half_spread
        (calculate_tax(modified_income, filing_status)).round
      else
        (calculate_tax income, filing_status).round
      end
    end

    def line_16
      get_tax_amount line_15, filing_status
    end

    def line_17
      # FUTURE: implement Schedule 2
      _d("0.0")
    end

    def line_18
      line_16 + line_17
    end

    def line_19
      amount = _d("0.0")
      @general.dependents.each do |depend|
        amount += 2000 if depend.child_credit
        amount += 500 if depend.other_credit
      end
      income = line_11
      limit = married_joint? ? _d("400000") : _d("200000")
      if income > limit
        # FUTURE: actually calculate the limited credit
      end
      reduction = 0
      if amount > reduction
        return amount - reduction
      else
        return _d("0")
      end
    end

    def line_20
      @us_sched3.line_7
    end

    def line_21
      line_19 + line_20
    end

    def line_22
      amount = line_18 - line_21
      amount < 0 ? _d("0.0") : amount
    end

    def line_23
      # FUTURE: implement schedule 2
      _d("0.0")
    end

    def line_24
      line_22 + line_23
    end

    def line_25a
      @income.w2s.sum { |w| _d(w.fed_wh) }
    end

    def line_25b
      # FUTURE: implement 1099 w/h
      _d("0.0")
    end

    def line_25c
      # FUTURE: other forms w/h
      _d("0.0")
    end

    def line_25d
      [line_25a, line_25b, line_25c].sum
    end

    def line_26
      # FUTURE: capture previous return payment
      _d("0.0")
    end

    def line_27
      # FUTURE: implement EIC
      _d("0.0")
    end

    def line_28
      # FUTURE: implement sched 8812
      _d("0.0")
    end

    def line_29
      # FUTURE: implement form 8863
      _d("0.0")
    end

    def line_30
      # TODO: recovery rebate credit?
      _d("0.0")
    end

    def line_31
      @us_sched3.line_13
    end

    def line_32
      [line_27, line_28, line_29, line_30, line_31].sum
    end

    def line_33
      [line_25d, line_26, line_32].sum
    end

    def line_34
      overpaid = line_33 - line_24
      overpaid > 0 ? overpaid : 0
    end

    def line_35a
      line_34
    end

    def line_35b
      @general.bank_routing
    end

    def line_35c
      @general.bank_type
    end

    def line_35d
      @general.bank_account
    end

    def line_37
      overpaid = line_33 - line_24
      overpaid < 0 ? overpaid.abs : 0
    end
  end
end
