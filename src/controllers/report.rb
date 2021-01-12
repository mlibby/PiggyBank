module PiggyBank
  class App < Sinatra::Base
    get "/report" do
      erb :"report/index",
          layout: :layout
    end
  end
end
