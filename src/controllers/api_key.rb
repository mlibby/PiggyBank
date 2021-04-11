module PiggyBank
  class App < Sinatra::Base
    def api_key_find(id)
      PiggyBank::ApiKey.find(api_key_id: id)
    end

    def api_key_index
      @api_keys = PiggyBank::ApiKey.all
      erb_layout :"api_key/index"
    end

    def api_key_new
      @method = "POST"
      @action = "/api_key"
      @header = "New API Key"
      erb_layout :"api_key/edit"
    end

    def api_key_create(params)
      api_key = PiggyBank::ApiKey.new(
        description: params["description"],
        value: params["value"],
      )
      api_key.save
      flash[:success] = "API key created."
      redirect to "/api_keys"
    end

    def api_key_view
      erb_layout :"api_key/view"
    end

    def api_key_edit
      @action = "/api_key/#{@api_key.api_key_id}"
      @method = "PUT"
      @header = "Edit API Key"

      erb_layout :"api_key/edit"
    end

    def api_key_update
      erb_layout :"api_key/view"
    end

    def api_key_diff(orig_api_key, new_api_key)
      @api_key = orig_api_key
      @new_api_key = new_api_key
      erb_layout :"api_key/diff"
    end

    def api_key_confirm
      @action = "/api_key/#{@api_key.api_key_id}"
      @method = "DELETE"
      erb_layout :"api_key/delete"
    end

    def api_key_delete
      @api_key.destroy
      flash[:success] = "API key deleted."
      redirect to "/api_keys"
    end

    # ROUTES

    get "/api_keys" do
      api_key_index
    end

    get "/api_key" do
      @api_key = PiggyBank::ApiKey.new
      api_key_new
    end

    post "/api_key" do
      if params["_token"] != PiggyBank::App.token
        @api_key = PiggyBank::ApiKey.new
        @api_key.set_fields params, PiggyBank::ApiKey.update_fields
        flash.now[:danger] = "Failed to create, please try again"
        halt 403, api_key_new
      else
        api_key_create params
      end
    end

    get "/api_key/:id" do |id|
      @api_key = api_key_find id
      if params.has_key? "edit"
        api_key_edit
      elsif params.has_key? "delete"
        api_key_confirm
      else
        api_key_view
      end
    end

    put "/api_key/:id" do |id|
      @api_key = api_key_find id
      if params["_token"] != PiggyBank::App.token
        @api_key.set_fields params, PiggyBank::ApiKey.update_fields
        flash.now[:danger] = "Failed to save changes, please try again"
        halt 403, api_key_edit
      elsif params["version"] != @api_key.version
        orig = @api_key.clone
        @api_key.set_fields params, PiggyBank::ApiKey.update_fields
        flash.now[:danger] = "Someone else updated this API key, please confirm changes"
        halt 409, api_key_diff(orig, @api_key)
      else
        @api_key.update_fields params, PiggyBank::ApiKey.update_fields
        api_key_update
      end
    end

    delete "/api_key/:id" do |id|
      @api_key = api_key_find id
      if params["_token"] != PiggyBank::App.token
        flash.now[:danger] = "Failed to delete, please try again"
        halt 403, api_key_confirm
      elsif params["version"] != @api_key.version
        flash.now[:danger] = "Someone else updated this API key, please re-confirm delete"
        halt 409, api_key_confirm
      else
        api_key_delete
      end
    end
  end
end
