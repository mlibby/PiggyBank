require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1 < PiggyBank::Tax::Form::Adapter::Base
    def dependents
      @general.dependents
    end

    def mn_campaign
      @general.mn_campaign
    end

    def spouse_mn_campaign
      @general.spouse_mn_campaign
    end 
  end
end
