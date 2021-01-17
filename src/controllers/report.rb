module PiggyBank
  class App < Sinatra::Base
    get "/report" do
      haml :"report/index",
           layout: :layout
    end
  end
end
