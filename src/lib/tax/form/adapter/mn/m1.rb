require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1 < PiggyBank::Tax::Form::Adapter::Base
    def initialize
      super
      @us_1040 = PiggyBank::Tax::Form::Adapter::US::Form1040.new
      @m1w = PiggyBank::Tax::Form::Adapter::MN::M1W.new
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
      @m1w.line_4
    end
  end
end
