module PiggyBank
  class App < Sinatra::Base
    get "/accounts" do
      haml :"account/index",
          layout: :layout 
          # TODO: pass list of accounts
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
