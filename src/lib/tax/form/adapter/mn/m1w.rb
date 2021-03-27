require "singleton"
require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1W < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    def line_1a1
      @income.w2s[0].ssn == @general.ssn ? "1" : "2"
    end

    def line_1b1
      @income.w2s[0].retirement_plan
    end

    def line_1c1
      @income.w2s[0].ein
    end

    def line_1d1
      _d(@income.w2s[0].state_wages)
    end

    def line_1e1
      _d(@income.w2s[0].state_tax)
    end

    def line_1a2
      @income.w2s[1]&.ssn == @general.ssn ? "1" : "2"
    end

    def line_1b2
      @income.w2s[1]&.retirement_plan
    end

    def line_1c2
      @income.w2s[1]&.ein
    end

    def line_1d2
      _d(@income.w2s[1]&.state_wages)
    end

    def line_1e2
      _d(@income.w2s[1]&.state_tax)
    end

    def line_1a3
      @income.w2s[2]&.ssn == @general.ssn ? "1" : "2"
    end

    def line_1b3
      @income.w2s[2]&.retirement_plan
    end

    def line_1c3
      @income.w2s[2]&.ein
    end

    def line_1d3
      _d(@income.w2s[2]&.state_wages)
    end

    def line_1e3
      _d(@income.w2s[2]&.state_tax)
    end

    def line_1
      [line_1e1, line_1e2, line_1e3].sum
    end

    def line_4
      line_1
    end
  end
end
