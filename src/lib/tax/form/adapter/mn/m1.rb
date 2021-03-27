require "singleton"
require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1 < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    attr_accessor :us_1040, :mn_m1w

    def initialize
      super
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

    def line_20
      @mn_m1w.line_4
    end
  end
end
