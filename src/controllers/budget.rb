class PiggyBank < Sinatra::Base
  get "/budget" do
    erb :"budget/index",
        layout: :layout
  end
end
