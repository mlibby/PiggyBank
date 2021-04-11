module PiggyBank
  class App < Sinatra::Base

    # FUTURE: plan budget feature

    get "/budget" do
      erb_layout :"budget/index"
    end
  end
end
