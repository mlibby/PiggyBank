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

    def account_create(params)
      name = params["name"]

      @account = PiggyBank::Account.create(
        name: name,
        type: params["type"],
        parent_id: params["parent_id"],
        commodity_id: params["commodity_id"],
        is_placeholder: params["is_placeholder"],
      )

      flash[:success] = "Account '#{name}' created."
      redirect to "/accounts"
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

    post "/account" do
      if params["_token"] != PiggyBank::App.token
        @account = PiggyBank::Account.new
        @account.set_fields params, PiggyBank::Account.update_fields
        flash.now[:danger] = "Failed to create, please try again"
        halt 403, account_new
      else
        account_create params
      end
    end

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
# ZZZ: POST /account = create account
# ZZZ: CSRF protection for /account
