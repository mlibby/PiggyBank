module PiggyBank
  class App < Sinatra::Base
    get "/import" do
      haml_layout :"import/index"
    end
  end
end
