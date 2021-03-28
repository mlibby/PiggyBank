require "singleton"
require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1C < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    def initialize
      super
      @mn_m1529 = M1529.new
      @mn_m1ma = M1MA.instance
    end

    def line_1
      @mn_m1ma.line_8
    end

    def line_7
      @mn_m1529.line_5
    end

    def line_17
      [line_1, line_7].sum
    end
  end
end
