require "singleton"
require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1 < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    attr_accessor :us_1040, :mn_m1sa, :mn_m1w

    def initialize
      super
      @us_sched1 = PiggyBank::Tax::Form::Adapter::US::Schedule1.new
    end

    def dependents
      @general.dependents
    end

    def mn_campaign
      @general.mn_campaign
    end

    def spouse_mn_campaign
      @general.spouse_mn_campaign
    end

    def line_A
      @us_1040.line_1
    end

    def line_D
      @us_1040.line_15
    end

    def line_1
      @us_1040.line_11
    end

    def line_2
      _d "0"
    end

    def line_3
      [line_1, line_2].sum
    end

    def mn_std_deductions
      {
        single: [_d("12400"), _d("14050"), _d("15700")],
        joint: [_d("24800"), _d("26100"), _d("27400"), _d("28700"), _d("30000")],
        widow: [_d("24800"), _d("26100"), _d("27400"), _d("28700"), _d("30000")],
        separate: [_d("12400"), _d("13700"), _d("15000"), _d("16300"), _d("17600")],
        hoh: [_d("18650"), _d("20300"), _d("21950")],
      }
    end

    # calculate standard deduction and compare to itemized,
    # use the larger of the two
    def line_4
      checks = 0
      checks += 1 if @general.birthday >= "1956-01-01"
      checks += 1 if @general.spouse_birthday >= "1956-01-01"
      checks += 1 if @general.blind
      checks += 1 if @general.spouse_blind

      std = mn_std_deductions[@general.filing_status.to_sym][checks]
      item = @mn_m1sa.line_27

      std > item ? std : item
    end

    def exemption_limits
      {
        joint: _d("296750"),
        widow: _d("296750"),
        single: _d("197850"),
        hoh: _d("247300"),
        separate: _d("148375"),
      }
    end

    # calculate exemptions
    def line_5
      step_1 = @us_1040.dependents.size
      step_2 = _d "4300"
      step_3 = step_1 * step_2
      step_4 = line_1
      step_5 = exemption_limits[@general.filing_status.to_sym]
      if step_5 > step_4
        return step_3
      end
      step_6 = step_4 - step_5
      if step_6 > 122500
        return _d("0")
      end
      step_7 = (step_6 / 2500).ceil
      step_8 = step_7 * 0.02
      step_9 = (step_8 * step_3).round
      step_3 - step_9
    end

    def line_6
      @us_sched1.line_1
    end

    def line_7
      _d "0"
    end

    def line_8
      [line_4, line_5, line_6, line_7].sum
    end

    def line_9
      line_3 - line_8
    end

    bracket = Struct.new(:max, :rate)
    TAX_BRACKETS = {
      single: [
        bracket.new(_d("26960.00"), _d("0.0535")),
        bracket.new(_d("88550.00"), _d("0.0680")),
        bracket.new(_d("164400.00"), _d("0.0785")),
        bracket.new(_d("Infinity"), _d("0.0985")),
      ],
      joint: [
        bracket.new(_d("39410.00"), _d("0.0535")),
        bracket.new(_d("156570.00"), _d("0.068")),
        bracket.new(_d("273480.00"), _d("0.0785")),
        bracket.new(_d("Infinity"), _d("0.0985")),
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
      if income <= _d("90000.0")
        spread = _d("100.0")

        half_spread = spread * _d("0.5")
        reduced_income = (income / spread).truncate
        modified_income = spread * reduced_income + half_spread
        (calculate_tax(modified_income, filing_status)).round
      else
        (calculate_tax income, filing_status).round
      end
    end

    def line_10
      get_tax_amount line_9, filing_status
    end

    def line_11
      _d "0"
    end

    def line_12
      line_10 + line_11
    end

    def line_13
      line_12
    end

    def line_14
      _d "0"
    end

    def line_15
      line_13 + line_14
    end

    def line_20
      @mn_m1w.line_4
    end
  end
end
