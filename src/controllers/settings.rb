module PiggyBank
  class App < Sinatra::Base
    get "/settings" do
      haml :"settings/index",
        layout: :layout,
        locals: {
          currency_options: [
            { value: "USD", name: "US Dollar", selected: true },
          ],
          locale_options: [
            { value: "en-US", name: "US English", selected: true },
          ]
        }
    end
  end
end
