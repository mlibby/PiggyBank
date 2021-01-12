module PiggyBank
  class App < Sinatra::Base
    get "/" do
      begin
        erb :"home/index", layout: :layout
      end
    end
  end
end
