module PiggyBank
  class App < Sinatra::Base
    get "/tool/mortgage" do
      haml :"tool/mortgage",
           layout: :layout
    end
  end
end
