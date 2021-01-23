module PiggyBank
  class App < Sinatra::Base
    def account_index
      @accounts = PiggyBank::Account.as_chart
      haml_layout :"account/index"
    end

    def account_new
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
      @account = PiggyBank::Account.new
      @account.parent = PiggyBank::Account.find(account_id: params[:parent_id])
      account_new
    end

    # TODO: POST /account = create account

    # TODO: GET /account/:id = view account
    # TODO: GET /account/:id?edit = edit account form
    # TODO: PUT /account/:id = update account

    # TODO: GET /account/:id?delete = confirm delete form
    # TODO: DELETE /account/:id = delete account

    # FUTURE: GET /accounts/import = import textual chart of accounts
    # FUTURE: GET /accounts/setup = preset account lists to choose from
  end
end

# ZZZ: pass list of accounts
# ZZZ: GET /account = new account form
