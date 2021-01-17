module PiggyBank
  class App < Sinatra::Base
    get "/" do
      begin
        haml :"home/index", layout: :layout
      end
    end
  end
end
