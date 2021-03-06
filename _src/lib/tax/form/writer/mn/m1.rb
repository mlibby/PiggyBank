require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1.instance
    end

    private

    def text_fields
      text_fields = {
        "yourfirstnameandinitial" => @adapter.first_name,
        "LastName" => @adapter.last_name,
        "YourSocialSecurityNumber" => @adapter.ssn,
        "YourDateofBirth" => @adapter.birthday,
        "SpousesFirstNameandInitial" => @adapter.spouse_first_name,
        "Spouseslastname" => @adapter.spouse_last_name,
        "SpousesSocialSecurityNumber" => @adapter.spouse_ssn,
        "spousesdateofbirth" => @adapter.spouse_birthday,
        "CurrentHomeAddress" => @adapter.address,
        "city" => @adapter.city,
        "state" => @adapter.state,
        "zipcode" => @adapter.zip,
        "Yourcode" => @adapter.mn_campaign,
        "Spousecode" => @adapter.spouse_mn_campaign,
        "Routingnumber" => @adapter.line_25_routing,
        "AccountNumber" => @adapter.line_25_account,
        "Taxpayersdaytimephone" => @adapter.contact_phone,
        "Youremailaddress" => @adapter.contact_email,
      }

      unless @adapter.dependents[0].nil?
        text_fields["dependent1first"] = @adapter.dependents[0].first_name
        text_fields["dependent1last"] = @adapter.dependents[0].last_name
        text_fields["dependent1ssn"] = @adapter.dependents[0].ssn
        text_fields["dependent1relationship"] = @adapter.dependents[0].relation
      end
      unless @adapter.dependents[1].nil?
        text_fields["dependent2first"] = @adapter.dependents[1].first_name
        text_fields["dependent2last"] = @adapter.dependents[1].last_name
        text_fields["dependent2ssn"] = @adapter.dependents[1].ssn
        text_fields["dependent2relationship"] = @adapter.dependents[1].relation
      end
      unless @adapter.dependents[2].nil?
        text_fields["dependent3first"] = @adapter.dependents[2].first_name
        text_fields["dependent3last"] = @adapter.dependents[2].last_name
        text_fields["dependent3ssn"] = @adapter.dependents[2].ssn
        text_fields["dependent3relationship"] = @adapter.dependents[2].relation
      end
      text_fields
    end

    def money_fields
      {
        "wages, salaries, tips" => @format.as_currency(@adapter.line_A),
        "FAGI" => @format.as_currency(@adapter.line_D),
        "m1line1" => @format.as_currency(@adapter.line_1),
        "m1line3" => @format.as_currency(@adapter.line_3),
        "m1line4" => @format.as_currency(@adapter.line_4),
        "m1line5" => @format.as_currency(@adapter.line_5),
        "m1line6" => @format.as_currency(@adapter.line_6),
        "m1line8" => @format.as_currency(@adapter.line_8),
        "m1line9" => @format.as_currency(@adapter.line_9),
        "m1line10" => @format.as_currency(@adapter.line_10),
        "m1line11" => @format.as_currency(@adapter.line_11),
        "m1line12" => @format.as_currency(@adapter.line_12),
        "m1line13" => @format.as_currency(@adapter.line_13),
        "m1line14" => @format.as_currency(@adapter.line_14),
        "m1line15" => @format.as_currency(@adapter.line_15),
        "m1line16" => @format.as_currency(@adapter.line_16),
        "m1line17" => @format.as_currency(@adapter.line_17),
        "m1line19" => @format.as_currency(@adapter.line_19),
        "m1line20" => @format.as_currency(@adapter.line_20),
        "m1line23" => @format.as_currency(@adapter.line_23),
        "m1line24" => @format.as_currency(@adapter.line_24),
        "m1line26" => @format.as_currency(@adapter.line_26),
      }
    end

    def button_fields
      {
        "checkifsingle" => @adapter.single?,
        "checkifmarriedfilingjoint" => @adapter.married_joint?,
        "checkifmarriedfilingseparately" => @adapter.married_separately?,
        "checkifheadofhousehold" => @adapter.head_of_household?,
        "checkifqualifyingwidower" => @adapter.qualified_widow?,
        "checkifchecking" => @adapter.line_25_type == "checking",
        "checkifsavings" => @adapter.line_25_type == "savings",
      }
    end

    def draw_fields
      set_field_values text_fields
      set_field_values money_fields
      set_field_values button_fields
    end
  end
end
