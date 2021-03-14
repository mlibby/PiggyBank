require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Schedule3 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f1040s3.pdf"
      super
      us_1040 = PiggyBank::Tax::Form::Adapter::US::Form1040.instance
      us_8863 = PiggyBank::Tax::Form::Adapter::US::Form8863.instance
      @adapter = PiggyBank::Tax::Form::Adapter::US::Schedule3.instance
      @adapter.us_8863 = us_8863
      us_8863.us_1040 = us_1040
      us_8863.us_sched3 = @adapter
    end

    private

    def text_fields
      {
        "form1[0].Page1[0].f1_01[0]" => @adapter.names,
        "form1[0].Page1[0].f1_02[0]" => @adapter.ssn,
      }
    end

    def money_fields
      {
        "form1[0].Page1[0].f1_05[0]" => @format.as_currency(@adapter.line_3),
        "form1[0].Page1[0].f1_10[0]" => @format.as_currency(@adapter.line_7),
      }
    end

  end
end
