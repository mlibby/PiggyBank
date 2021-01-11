class PiggyBank < Sinatra::Base
  get "/settings" do
    erb :"settings/index",
        layout: :layout
  end
end
