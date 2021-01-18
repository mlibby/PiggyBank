module PiggyBank
  class App < Sinatra::Base

    # TODO: plan budget feature

    get "/budget" do
      haml :"budget/index",
           layout: :layout
    end
  end
end
