require "sinatra/base"

class PiggyBank < Sinatra::Base
  get "/" do
    begin
      erb :"home/index", layout: :layout
    end
  end
end
