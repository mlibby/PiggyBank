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
      @income.w2s.sum { |w| BigDecimal(w.wages) }
    end

    def line_2b
      BigDecimal("0.0")
    end

    def line_3b
      BigDecimal("0.0")
    end

    def line_4b
      BigDecimal("0.0")
    end

    def line_5b
      BigDecimal("0.0")
    end

    def line_6b
      BigDecimal("0.0")
    end

    def line_7
      BigDecimal("0.0")
    end

    def line_8
      @sched1.line_9
    end

    def line_9
      [line_1, line_2b, line_3b, line_4b, line_5b, line_6b, line_7, line_8].sum
    end

    def line_10c
      BigDecimal("0.0")
    end

    def line_11
      line_9 - line_10c
    end

    STANDARD_DEDUCTIONS = {
      single: BigDecimal("12400.0"),
      joint: BigDecimal("24800.0"),
      separate: BigDecimal("12400.0"),
      hoh: BigDecimal("18650.0"),
      widow: BigDecimal("24800.0"),
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
      BigDecimal("0.0")
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
        bracket.new(BigDecimal("9875.00"), 0.1),
        bracket.new(BigDecimal("40125.00"), 0.12),
        bracket.new(BigDecimal("85525.00"), 0.22),
        bracket.new(BigDecimal("163300.00"), 0.24),
        bracket.new(BigDecimal("207350.00"), 0.32),
        bracket.new(BigDecimal("518400.00"), 0.35),
        bracket.new(BigDecimal("Infinity"), 0.37),
      ],
      joint: [
        bracket.new(BigDecimal("19750.00"), 0.10),
        bracket.new(BigDecimal("80250.00"), 0.12),
        bracket.new(BigDecimal("171050.00"), 0.22),
        bracket.new(BigDecimal("326600.00"), 0.24),
        bracket.new(BigDecimal("414700.00"), 0.32),
        bracket.new(BigDecimal("622050.00"), 0.35),
        bracket.new(BigDecimal("Infinity"), 0.37),
      ],
      separate: [
        bracket.new(BigDecimal("9875.00"), 0.10),
        bracket.new(BigDecimal("40125.00"), 0.12),
        bracket.new(BigDecimal("85525.00"), 0.22),
        bracket.new(BigDecimal("163300.00"), 0.24),
        bracket.new(BigDecimal("207350.00"), 0.32),
        bracket.new(BigDecimal("311025.00"), 0.35),
        bracket.new(BigDecimal("Infinity"), 0.37),
      ],
      hoh: [
        bracket.new(BigDecimal("14100.00"), 0.10),
        bracket.new(BigDecimal("53700.00"), 0.12),
        bracket.new(BigDecimal("85500.00"), 0.22),
        bracket.new(BigDecimal("163300.00"), 0.24),
        bracket.new(BigDecimal("207350.00"), 0.32),
        bracket.new(BigDecimal("518400.00"), 0.35),
        bracket.new(BigDecimal("Infinity"), 0.37),
      ],
      widow: [
        bracket.new(BigDecimal("19750.00"), 0.10),
        bracket.new(BigDecimal("80250.00"), 0.12),
        bracket.new(BigDecimal("171050.00"), 0.22),
        bracket.new(BigDecimal("326600.00"), 0.24),
        bracket.new(BigDecimal("414700.00"), 0.32),
        bracket.new(BigDecimal("622050.00"), 0.35),
        bracket.new(BigDecimal("Infinity"), 0.37),
      ],
    }

    def calculate_tax
      agi = line_15
      tax = BigDecimal("0.0")
      min = BigDecimal("0.0")
      TAX_BRACKETS[filing_status].each do |bracket|
        if agi >= bracket.max
          tax += bracket.max * bracket.rate
          min = bracket.max
        else
          tax += (agi - min) * bracket.rate
          break
        end
      end
      tax
    end

    def line_16
      calculate_tax
    end
  end
end
