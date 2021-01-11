class PiggyBank < Sinatra::Base
  get "/tool/mortgage" do
    erb :"tool/mortgage",
        layout: :layout
  end
end
