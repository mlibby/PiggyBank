module PiggyBank
  class App < Sinatra::Base
    def ofx_find(id)
      PiggyBank::Ofx.find(ofx_id: id)
    end

    def ofx_index
      @ofxs = PiggyBank::Ofx.all
      erb_layout :"ofx/index"
    end

    def ofx_new
      @method = "POST"
      @action = "/ofx"
      @header = "New OFX Configuration"
      erb_layout :"ofx/edit"
    end

    def ofx_create(params)
      ofx = PiggyBank::Ofx.new
      ofx.set_fields params, PiggyBank::Ofx.update_fields
      ofx.save
      flash[:success] = "OFX configuration created."
      redirect to "/ofxs"
    end

    def ofx_view
      erb_layout :"ofx/view"
    end

    def ofx_edit
      @action = "/ofx/#{@ofx.ofx_id}"
      @method = "PUT"
      @header = "Edit OFX Configuration"

      erb_layout :"ofx/edit"
    end

    def ofx_update
      erb_layout :"ofx/view"
    end

    def ofx_diff(orig_ofx, new_ofx)
      @ofx = orig_ofx
      @new_ofx = new_ofx
      erb_layout :"ofx/diff"
    end

    def ofx_confirm
      @action = "/ofx/#{@ofx.ofx_id}"
      @method = "DELETE"
      erb_layout :"ofx/delete"
    end

    def ofx_delete
      @ofx.destroy
      flash[:success] = "OFX configuration deleted."
      redirect to "/ofxs"
    end

    # ROUTES

    get "/ofxs" do
      ofx_index
    end

    get "/ofx" do
      @ofx = PiggyBank::Ofx.new
      ofx_new
    end

    post "/ofx" do
      if params["_token"] != PiggyBank::App.token
        @ofx = PiggyBank::Ofx.new
        @ofx.set_fields params, PiggyBank::Ofx.update_fields
        flash.now[:danger] = "Failed to create, please try again"
        halt 403, ofx_new
      else
        ofx_create params
      end
    end

    get "/ofx/:id" do |id|
      @ofx = ofx_find id
      if params.has_key? "edit"
        ofx_edit
      elsif params.has_key? "delete"
        ofx_confirm
      else
        ofx_view
      end
    end

    put "/ofx/:id" do |id|
      @ofx = ofx_find id
      if params["_token"] != PiggyBank::App.token
        @ofx.set_fields params, PiggyBank::Ofx.update_fields
        flash.now[:danger] = "Failed to save changes, please try again"
        halt 403, ofx_edit
      elsif params["version"] != @ofx.version
        orig = @ofx.clone
        @ofx.set_fields params, PiggyBank::Ofx.update_fields
        flash.now[:danger] = "Someone else updated this OFX configuration, please confirm changes"
        halt 409, ofx_diff(orig, @ofx)
      else
        @ofx.update_fields params, PiggyBank::Ofx.update_fields
        ofx_update
      end
    end

    delete "/ofx/:id" do |id|
      @ofx = ofx_find id
      if params["_token"] != PiggyBank::App.token
        flash.now[:danger] = "Failed to delete, please try again"
        halt 403, ofx_confirm
      elsif params["version"] != @ofx.version
        flash.now[:danger] = "Someone else updated this OFX configuration, please re-confirm delete"
        halt 409, ofx_confirm
      else
        ofx_delete
      end
    end
  end
end
