module PiggyBank
  class App < Sinatra::Base
    get "/tax" do
      haml_layout :"tax/index"
    end

    get "/tax/forms" do
      haml_layout :"tax/forms"
    end
  end
end