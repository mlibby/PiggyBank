module PiggyBank
  class App < Sinatra::Base
    def general_form
      haml_layout :"tax/data/general"
    end

    get "/tax/data" do
      haml_layout :"tax/data"
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
      haml_layout :"tax/data/income"
    end

    post "/tax/data/income" do
      haml_layout :"tax/data/income"
    end

    get "/tax/data/deduct" do
      haml_layout :"tax/data/deduct"
    end

    post "/tax/data/deduct" do
      haml_layout :"tax/data/deduct"
    end

    get "/tax/data/tax" do
      haml_layout :"tax/data/tax"
    end

    post "/tax/data/tax" do
      haml_layout :"tax/data/tax"
    end

    get "/tax/forms" do
      haml_layout :"tax/forms"
    end

    get "/tax/form/:unit/:form" do |unit, form|
      haml_layout :"tax/form/#{unit}/#{form}"
    end
  end
end
