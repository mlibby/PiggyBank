module PiggyBank
  class App < Sinatra::Base
    get "/budget" do
      haml :"budget/index",
           layout: :layout
    end
  end
end
