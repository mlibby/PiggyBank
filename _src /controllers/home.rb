module PiggyBank
  class App < Sinatra::Base
    get "/" do
      begin
        erb_layout :"home/index"
      end
    end
  end
end
