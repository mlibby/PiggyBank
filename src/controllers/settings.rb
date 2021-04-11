module PiggyBank
  class App < Sinatra::Base
    get "/settings" do
      @currency_options = [
        { value: "USD", name: "US Dollar", selected: true },
      ]
      @locale_options = [
        { value: "en-US", name: "US English", selected: true },
      ]
      erb_layout :"settings/index"
    end
  end
end
