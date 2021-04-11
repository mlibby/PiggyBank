module PiggyBank
  class App < Sinatra::Base
    get "/import" do
      erb_layout :"import/index"
    end
  end
end
