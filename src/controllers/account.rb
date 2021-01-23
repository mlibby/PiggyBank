module PiggyBank
  class App < Sinatra::Base
    def account_find(id)
      PiggyBank::Account.find(account_id: id)
    end

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
      @account = PiggyBank::Account.create(
        name: params["name"],
        type: params["type"],
        parent_id: params["parent_id"],
        commodity_id: params["commodity_id"],
        is_placeholder: params["is_placeholder"].nil? ? false : true,
      )

      flash[:success] = "Account '#{@account.name}' created."
      redirect to "/accounts"
    end

    def account_view
      haml_layout :"account/view"
    end

    def account_edit
      @action = "/account/#{@account.account_id}"
      @method = "PUT"
      @header = "Edit Account"

      haml_layout :"account/edit"
    end

    # def account_update
    #   haml :"account/view"
    # end

    # def account_diff(orig_account, new_account)
    #   @account = orig_account
    #   @new_account = new_account
    #   haml :"account/diff"
    # end

    # def account_confirm
    #   @action = "/account/#{@account.account_id}"
    #   @method = "DELETE"

    #   haml_layout :"account/delete"
    # end

    # def account_delete
    #   flash[:success] = "account '#{@account.name}' deleted."
    #   @account.destroy
    #   redirect to "/commodities"
    # end

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

    get "/account/:id" do |id|
      @account = account_find id
      if params.has_key? "edit"
        account_edit
        #   elsif params.has_key? "delete"
        #     account_confirm
      else
        account_view
      end
    end

    # post "/account" do
    #   if params["_token"] != PiggyBank::App.token
    #     @account = PiggyBank::account.new
    #     @account.set_fields params, PiggyBank::account.update_fields
    #     flash.now[:danger] = "Failed to create, please try again"
    #     halt 403, account_new
    #   else
    #     account_create params
    #   end
    # end

    # put "/account/:id" do |id|
    #   @account = account_find id
    #   if params["_token"] != PiggyBank::App.token
    #     @account.set_fields params, PiggyBank::account.update_fields
    #     flash.now[:danger] = "Failed to save changes, please try again"
    #     halt 403, account_edit
    #   elsif params["version"] != @account.version
    #     orig = @account.clone
    #     @account.set_fields params, PiggyBank::account.update_fields
    #     flash.now[:danger] = "Someone else updated this account, please confirm changes"
    #     halt 409, account_diff(orig, @account)
    #   else
    #     @account.update_fields params, PiggyBank::account.update_fields
    #     account_update
    #   end
    # end

    # delete "/account/:id" do |id|
    #   @account = account_find id
    #   if params["_token"] != PiggyBank::App.token
    #     flash.now[:danger] = "Failed to delete, please try again"
    #     halt 403, account_confirm
    #   elsif params["version"] != @account.version
    #     flash.now[:danger] = "Someone else updated this account, please re-confirm delete"
    #     halt 409, account_confirm
    #   else
    #     account_delete
    #   end
    # end
  end
end
