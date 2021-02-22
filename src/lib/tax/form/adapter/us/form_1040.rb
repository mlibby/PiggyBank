require_relative "../base.rb"

module PiggyBank::Tax::Form::Adapter::US
  class Form1040 < PiggyBank::Tax::Form::Adapter::Base
    def initialize
      super
      @sched1 = PiggyBank::Tax::Form::Adapter::US::Schedule1.new
      @scheda = PiggyBank::Tax::Form::Adapter::US::ScheduleA.new
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
      @income.w2s.sum { |w| _d(w.wages) }
    end

    def line_2b
      _d("0.0")
    end

    def line_3b
      _d("0.0")
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
  end
end
