require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1529 < PiggyBank::Tax::Form::Adapter::Base
    def initialize
      super
      @mn_m1 = M1.instance
    end

    def line_1_fi_1
      @education.m1529_name_1
    end

    def line_1_account_1
      @education.m1529_account_1
    end

    def line_1_amount_1
      _d(@education.m1529_amount_1)
    end

    def line_1_fi_2
      @education.m1529_name_2
    end

    def line_1_account_2
      @education.m1529_account_2
    end

    def line_1_amount_2
      _d(@education.m1529_amount_2)
    end

    def line_1
      [line_1_amount_1, line_1_amount_2].sum
    end

    def line_3
      line_1
    end

    def line_5
      step_2 = line_3 * 0.5
      step_3 = @mn_m1.line_1
      step_5 = nil
      step_7 = nil
      step_9 = nil
      step_10 = _d("500")
      if step_3 >= 79640
        if @general.filing_status == "joint"
          if 79640 <= step_3 && step_3 < 104640
            step_5 = _d("79640")
            step_7 = _d("0.01")
            step_9 = _9("500")
          elsif 104640 <= step_3 && step_3 < 143350
            step_5 = _d("0")
            step_7 = _d("0")
            step_9 = _d("250")
          else
            step_5 = _d("143350")
            step_7 = _d("0.01")
            step_9 = _d("250")
          end
        else
          step_5 = _d("79640")
          step_7 = _d("0.02")
          step_9 = _d("500")
        end

        step_6 = step_3 - step_5
        step_8 = step_6 * step_7
        step_10 = step_9 - step_8
      end
      step_11 = [step_2, step_10].min
      # steps = [step_2, step_3, step_5, step_6, step_7, step_8, step_9, step_10, step_11]
      # p @general.filing_status
      # p steps.map { |s| s.to_f }
      step_11
    end
  end
end
