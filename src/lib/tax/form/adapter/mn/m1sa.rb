require "singleton"
require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1SA < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    attr_accessor :mn_m1, :us_scheda

    def line_2
      @mn_m1.line_1
    end

    def line_3
      (line_2 * 0.1).round
    end

    def line_4
      _d("0")
    end

    def line_5
      @us_scheda.line_5b
    end

    def line_6
      @us_scheda.line_5c
    end

    def line_7
      line_5 + line_6
    end

    def line_8
      line_7 < 10000 ? line_7 : d("10000")
    end

    def line_10
      line_8
    end

    def line_11
      @us_scheda.line_8a
    end

    def line_12
      _d "0"
    end

    def line_13
      @us_scheda.line_9
    end

    def line_14
      [line_11, line_12, line_13].sum
    end

    def line_15
      @us_scheda.line_11
    end

    def line_16
      @us_scheda.line_12
    end

    def line_17
      _d "0"
    end

    def line_18
      [line_15, line_16, line_17].sum
    end

    def line_25
      [line_4, line_10, line_14, line_18].sum
    end

    def line_27
      line_25
    end
  end
end
