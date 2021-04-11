module PiggyBank
  class App < Sinatra::Base
    get "/tool/mortgage" do
      erb_layout :"tool/mortgage"
    end
  end
end
