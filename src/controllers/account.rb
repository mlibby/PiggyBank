module PiggyBank
  class App < Sinatra::Base
    def account_index
      #@accounts = PiggyBank::Account.as_chart
      haml_layout :"account/index"
    end

    get "/accounts" do
      account_index
    end

    # TODO: GET /account/new = new account form

    # TODO: POST /account = create account

    # TODO: GET /account/:id = edit account form

    # TODO: PUT /account/:id = update account

    # TODO: GET /account/delete = confirm delete

    # TODO: DELETE /account/:id = delete account

    # TODO: GET /accounts/import = import textual chart of accounts

    # TODO: GET /accounts/setup = preset account lists to choose from
  end
end

# TODO: pass list of accounts
