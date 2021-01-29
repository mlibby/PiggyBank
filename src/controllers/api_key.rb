module PiggyBank
  class App < Sinatra::Base
    # def api_key_find(id)
    #   PiggyBank::ApiKey.find(api_key_id: id)
    # end

    def api_key_index
      @api_keys = PiggyBank::ApiKey.all
      haml_layout :"api_key/index"
    end

    # def api_key_new
    #   @method = "POST"
    #   @action = "/api_key"
    #   @header = "New Transaction"
    #   haml_layout :"api_key/edit"
    # end

    # def api_key_create(params)
    #   api_key = PiggyBank::ApiKey.new(
    #     post_date: params["post_date"],
    #     number: params["number"],
    #     description: params["description"],
    #   )
    #   splits = []
    #   0.upto(params["splits"].length - 1) do |i|
    #     splits << PiggyBank::Split.new(
    #       memo: params["splits"][i]["memo"],
    #       account_id: params["splits"][i]["account_id"],
    #       amount: params["splits"][i]["amount"],
    #       value: params["splits"][i]["value"],
    #     )
    #   end

    #   api_key.save
    #   splits.each do |split|
    #     api_key.add_split split
    #   end
    #   api_key.save

    #   flash[:success] = "Transaction created."
    #   redirect to "/api_keys"
    # end

    # def api_key_view
    #   haml_layout :"api_key/view"
    # end

    # def api_key_edit
    #   @action = "/api_key/#{@api_key.api_key_id}"
    #   @method = "PUT"
    #   @header = "Edit Transaction"

    #   haml_layout :"api_key/edit"
    # end

    # def api_key_update
    #   haml :"api_key/view"
    # end

    # def api_key_diff(orig_api_key, new_api_key)
    #   @api_key = orig_api_key
    #   @new_api_key = new_api_key
    #   haml :"api_key/diff"
    # end

    # def api_key_confirm
    #   @action = "/api_key/#{@api_key.api_key_id}"
    #   @method = "DELETE"
    #   haml_layout :"api_key/delete"
    # end

    # def api_key_delete
    #   @api_key.splits.each do |split|
    #     split.destroy
    #   end
    #   @api_key.destroy
    #   flash[:success] = "Transaction deleted."
    #   redirect to "/api_keys"
    # end

    # ROUTES

    get "/api_keys" do
      api_key_index
    end

    # get "/api_key" do
    #   @api_key = PiggyBank::ApiKey.new
    #   @api_key.splits << PiggyBank::Split.new
    #   @api_key.splits << PiggyBank::Split.new
    #   api_key_new
    # end

    # post "/api_key" do
    #   if params["_token"] != PiggyBank::App.token
    #     @api_key = PiggyBank::ApiKey.new
    #     @api_key.set_fields params, PiggyBank::ApiKey.update_fields
    #     @api_key.splits << PiggyBank::Split.new
    #     @api_key.splits << PiggyBank::Split.new
    #     flash.now[:danger] = "Failed to create, please try again"
    #     halt 403, api_key_new
    #   else
    #     api_key_create params
    #   end
    # end

    # get "/api_key/:id" do |id|
    #   @api_key = api_key_find id
    #   if params.has_key? "edit"
    #     api_key_edit
    #   elsif params.has_key? "delete"
    #     api_key_confirm
    #   else
    #     api_key_view
    #   end
    # end

    # put "/api_key/:id" do |id|
    #   @api_key = api_key_find id
    #   if params["_token"] != PiggyBank::App.token
    #     @api_key.set_fields params, PiggyBank::ApiKey.update_fields
    #     flash.now[:danger] = "Failed to save changes, please try again"
    #     halt 403, api_key_edit
    #   elsif params["version"] != @api_key.version
    #     orig = @api_key.clone
    #     @api_key.set_fields params, PiggyBank::ApiKey.update_fields
    #     flash.now[:danger] = "Someone else updated this api_key, please confirm changes"
    #     halt 409, api_key_diff(orig, @api_key)
    #   else
    #     @api_key.update_fields params, PiggyBank::ApiKey.update_fields
    #     api_key_update
    #   end
    # end

    # delete "/api_key/:id" do |id|
    #   @api_key = api_key_find id
    #   if params["_token"] != PiggyBank::App.token
    #     flash.now[:danger] = "Failed to delete, please try again"
    #     halt 403, api_key_confirm
    #   elsif params["version"] != @api_key.version
    #     flash.now[:danger] = "Someone else updated this api_key, please re-confirm delete"
    #     halt 409, api_key_confirm
    #   else
    #     api_key_delete
    #   end
    # end
  end
end
