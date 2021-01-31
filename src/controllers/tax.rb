module PiggyBank
  class App < Sinatra::Base
    get "/tax/data" do
      haml_layout :"tax/data"
    end

    get "/tax/data/general" do
      @general = PiggyBank::Tax::General.new
      haml_layout :"tax/data/general"
    end

    post "/tax/data/general" do
      @general = PiggyBank::Tax::General.new
      haml_layout :"tax/data/general"
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