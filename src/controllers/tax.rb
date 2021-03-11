module PiggyBank
  class App < Sinatra::Base
    def general_form
      haml_layout :"tax/data/general/index"
    end

    def income_form
      haml_layout :"tax/data/income/index"
    end

    def deduct_form
      haml_layout :"tax/data/deduct/index"
    end

    get "/tax/data" do
      haml_layout :"tax/data/index"
    end

    get "/tax/data/general" do
      @general = PiggyBank::Tax::Data::General.instance
      general_form
    end

    post "/tax/data/general" do
      @general = PiggyBank::Tax::Data::General.instance
      @general.update params

      if params.has_key? "add_dep"
        @general.add_dependent
        general_form
      elsif params.has_key? "rm_dep"
        @general.rm_dependent params["rm_dep"]
        general_form
      else
        @general.save
        flash[:success] = "General tax data saved."
        redirect to "/tax/data"
      end
    end

    get "/tax/data/income" do
      @income = PiggyBank::Tax::Data::Income.instance
      haml_layout :"tax/data/income/index"
    end

    post "/tax/data/income" do
      @income = PiggyBank::Tax::Data::Income.instance
      @income.update params

      if params.has_key? "add_w2"
        @income.add_w2
        income_form
      elsif params.has_key? "rm_w2"
        @income.rm_w2 params["rm_w2"]
        income_form
      elsif params.has_key? "add_f1099_div"
        @income.add_f1099_div
        income_form
      elsif params.has_key? "rm_f1099_div"
        @income.rm_f1099_div params["rm_f1099_div"]
        income_form
      elsif params.has_key? "add_f1099_int"
        @income.add_f1099_int
        income_form
      elsif params.has_key? "rm_f1099_int"
        @income.rm_f1099_int params["rm_f1099_int"]
        income_form
      elsif params.has_key? "add_rental"
        @income.add_rental
        income_form
      elsif params.has_key? "rm_rental"
        @income.rm_rental params["rm_rental"]
        income_form
      else
        @income.save
        flash[:success] = "Income data saved."
        redirect to "/tax/data"
      end
    end

    get "/tax/data/deduct" do
      @deduct = PiggyBank::Tax::Data::Deduct.instance
      deduct_form
    end

    post "/tax/data/deduct" do
      @deduct = PiggyBank::Tax::Data::Deduct.instance
      @deduct.update params

      if params.has_key? "add_1098"
        @deduct.add_1098
        deduct_form
      elsif params.has_key? "rm_1098"
        @deduct.rm_1098 params["rm_1098"]
        deduct_form
      elsif params.has_key? "add_cd"
        @deduct.add_cd
        deduct_form
      elsif params.has_key? "rm_cd"
        @deduct.rm_cd params["rm_cd"]
        deduct_form
      elsif params.has_key? "add_ncd"
        @deduct.add_ncd
        deduct_form
      elsif params.has_key? "rm_ncd"
        @deduct.rm_ncd params["rm_ncd"]
        deduct_form
      else
        @deduct.save
        flash[:success] = "Deduction data saved."
        redirect to "/tax/data"
      end
    end

    get "/tax/data/education" do
      @education = PiggyBank::Tax::Data::Education.instance
      haml_layout :"tax/data/education/index"
    end

    post "/tax/data/education" do
      @education = PiggyBank::Tax::Data::Education.instance
      @education.update params
      @education.save
      flash[:success] = "Education data saved."
      redirect to "/tax/data"
    end

    get "/tax/forms" do
      @us_8283_count = PiggyBank::Tax::Form::Adapter::US::Form8283.count
      haml_layout :"tax/form/index"
    end

    get "/tax/form/us/form_8283/:form_number" do |fn|
      writer = PiggyBank::Tax::Form::Writer::US::Form8283.new fn
      pdf = writer.write_form
      halt 200, { "Content-Type" => "application/pdf" }, pdf
    end

    forms = {
      "us" => {
        "form_1040" => PiggyBank::Tax::Form::Writer::US::Form1040,
        "form_6198" => PiggyBank::Tax::Form::Writer::US::Form6198,
        "form_8582" => PiggyBank::Tax::Form::Writer::US::Form8582,
        "form_8863" => PiggyBank::Tax::Form::Writer::US::Form8863,
        "form_8889" => PiggyBank::Tax::Form::Writer::US::Form8889,
        "sched_1" => PiggyBank::Tax::Form::Writer::US::Schedule1,
        "sched_3" => PiggyBank::Tax::Form::Writer::US::Schedule3,
        "sched_a" => PiggyBank::Tax::Form::Writer::US::ScheduleA,
        "sched_b" => PiggyBank::Tax::Form::Writer::US::ScheduleB,
        "sched_e" => PiggyBank::Tax::Form::Writer::US::ScheduleE,
      },
      "mn" => {
        "m1" => PiggyBank::Tax::Form::Writer::MN::M1,
        "m1c" => PiggyBank::Tax::Form::Writer::MN::M1C,
        "m1m" => PiggyBank::Tax::Form::Writer::MN::M1M,
        "m1ma" => PiggyBank::Tax::Form::Writer::MN::M1MA,
        "m1sa" => PiggyBank::Tax::Form::Writer::MN::M1SA,
        "m1w" => PiggyBank::Tax::Form::Writer::MN::M1W,
        "m1529" => PiggyBank::Tax::Form::Writer::MN::M1529,
      },
    }

    forms.each_key do |group|
      forms[group].each_pair do |form, writer|
        get "/tax/form/#{group}/#{form}" do
          pdf = writer.new.write_form
          halt 200, { "Content-Type" => "application/pdf" }, pdf
        end
      end
    end
  end
end
