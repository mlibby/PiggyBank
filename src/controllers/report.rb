class PiggyBank < Sinatra::Base
  get "/report" do
    erb :"report/index",
        layout: :layout
  end
end
