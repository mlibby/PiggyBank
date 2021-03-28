module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end

module PiggyBank::Tax::Form::Adapter
  class Loader
    def self.load_adapters
      us_1040 = US::Form1040.instance
      us_6198 = US::Form6198.instance
      us_8582 = US::Form8582.instance
      us_8863 = US::Form8863.instance
      us_sched3 = US::Schedule3.instance
      us_scheda = US::ScheduleA.instance
      us_schede = US::ScheduleE.instance

      us_1040.us_sched3 = us_sched3
      us_1040.us_scheda = us_scheda
      us_6198.us_schede = us_schede
      us_8582.us_6198 = us_6198
      us_8582.us_schede = us_schede
      us_8863.us_1040 = us_1040
      us_8863.us_sched3 = us_sched3
      us_sched3.us_8863 = us_8863
      us_schede.us_6198 = us_6198
      us_schede.us_8582 = us_8582

      mn_m1 = MN::M1.instance
      mn_m1sa = MN::M1SA.instance
      mn_m1w = MN::M1W.instance

      mn_m1.mn_m1sa = mn_m1sa
      mn_m1.mn_m1w = mn_m1w
      mn_m1.us_1040 = us_1040
      mn_m1sa.mn_m1 = mn_m1
      mn_m1sa.us_scheda = us_scheda
    end
  end
end
