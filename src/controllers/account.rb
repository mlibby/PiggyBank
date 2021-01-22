module PiggyBank
  class App < Sinatra::Base
    def account_index
      @accounts = PiggyBank::Account.as_chart
      haml_layout :"account/index"
    end

    def account_new
      @account ||= PiggyBank::Account.new

      @method = "POST"
      @action = "/account"
      @header = "New Account"

      haml_layout :"account/edit"
    end

    # ROUTES

    get "/accounts" do
      account_index
    end

    get "/account" do
      account_new
    end

    # TODO: POST /account = create account

    # TODO: GET /account/:id = edit account form

    # TODO: PUT /account/:id = update account

    # TODO: GET /account/delete = confirm delete

    # TODO: DELETE /account/:id = delete account

    # TODO: GET /accounts/import = import textual chart of accounts

    # TODO: GET /accounts/setup = preset account lists to choose from
  end
end

# ZZZ: pass list of accounts
# ZZZ: GET /account = new account form
