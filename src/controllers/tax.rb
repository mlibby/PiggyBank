module PiggyBank
  class App < Sinatra::Base
    def general_form
      haml_layout :"tax/data/general/index"
    end

    def income_form
      haml_layout :"tax/data/income/index"
    end

    get "/tax/data" do
      haml_layout :"tax/data/index"
    end

    get "/tax/data/general" do
      @general = PiggyBank::Tax::General.new
      general_form
    end

    post "/tax/data/general" do
      @general = PiggyBank::Tax::General.new
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
      @income = PiggyBank::Tax::Income.new
      haml_layout :"tax/data/income/index"
    end

    post "/tax/data/income" do
      @income = PiggyBank::Tax::Income.new
      @income.update params

      if params.has_key? "add_w2"
        @income.add_w2
        income_form
      elsif params.has_key? "rm_w2"
        @income.rm_w2 params["rm_w2"]
        income_form
      else
        @income.save
        flash[:success] = "Income data saved."
        redirect to "/tax/data"
      end
    end

    get "/tax/data/deduct" do
      haml_layout :"tax/data/deduct/index"
    end

    post "/tax/data/deduct" do
      haml_layout :"tax/data/deduct/index"
    end

    get "/tax/data/tax" do
      haml_layout :"tax/data/tax/index"
    end

    post "/tax/data/tax" do
      haml_layout :"tax/data/tax/index"
    end

    get "/tax/forms" do
      haml_layout :"tax/form/index"
    end

    get "/tax/form/:unit/:form" do |unit, form|
      haml_layout :"tax/form/#{unit}/#{form}"
    end
  end
end
