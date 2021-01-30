require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "get /ofxs" do
    it "has a list of OFX configs" do
      response = get "/ofxs"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "OFX Configurations"
    end
  end

  context "GET /ofx" do
    it "gives a new OFX form" do
      response = get "/ofx"

      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "New OFX Configuration"
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/ofx",
        },
      )
    end
  end

  def create_params
    ofx = {
      _token: PiggyBank::App.token,
      active: true,
      account_id: PiggyBank::Account.find(name: "Assets").account_id,
      url: "foo.bar.com",
      user: "ofx user",
      password: "ofx pass",
      fid: "12345",
      fid_org: "B1",
      bank_id: "x",
      bank_account_id: "*****",
      account_type: "CHECKING",
    }
  end

  context "POST /ofx" do
    it "redirects to /ofxs" do
      response = post "/ofx", create_params
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/ofxs"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "OFX configuration created."
    end
  end

  context "POST /ofx with invalid token" do
    it "politely refuses to create" do
      params = create_params
      params[:_token] = "bad token"
      response = post "/ofx", params

      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "New OFX Configuration"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
    end
  end

  context "GET /ofx/:id" do
    it "shows the OFX config" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)
      response = get "/ofx/#{ofx.ofx_id}"

      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "OFX Configuration 'Assets'"
    end
  end

  context "GET /ofx/:id?edit" do
    it "has an edit form" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)
      response = get "/ofx/#{ofx.ofx_id}?edit"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Edit OFX Configuration"
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
        with_tag "input", with: { name: "version", type: "hidden", value: ofx.version }
      end
    end
  end

  context "GET /ofx/:id?delete" do
    it "has a delete confirmation form" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)
      response = get "/ofx/#{ofx.ofx_id}?delete"
      expect(response.body).to include "Delete OFX Configuration?"
      expect(response.status).to eq 200
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/ofx/#{ofx.ofx_id}",
        },
      ) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
        with_tag "input", with: { name: "version", type: "hidden", value: ofx.version }
      end
    end
  end

  def update_params(existing)
    ofx = {
      _token: PiggyBank::App.token,
      active: true,
      account_id: PiggyBank::Account.find(name: "Equity").account_id,
      url: "foz.baz.com",
      user: "user ofx",
      password: "pass ofx",
      fid: "98765",
      fid_org: "C2",
      bank_id: "y",
      bank_account_id: "#####",
      account_type: "SAVINGS",
      version: existing.version,
    }
  end

  context "PUT /ofx/:id with valid params" do
    it "updates the DB" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)

      response = put "/ofx/#{ofx.ofx_id}", update_params(ofx)

      expect(response.status).to eq 200

      ofx = PiggyBank::Ofx.find(ofx_id: ofx.ofx_id)
      equity = PiggyBank::Account.find(name: "Equity").account_id
      
    end
  end

  context "PUT /ofx/:id with invalid token" do
    it "politely refuses to update" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)

      params = update_params ofx
      params[:_token] = "bad token"
      response = put "/ofx/#{ofx.ofx_id}", params
 
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Edit OFX Configuration"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
    end
  end

  context "PUT /ofx/:id with version mismatch" do
    it "politely refuses to update" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)

      params = update_params ofx
      params[:version] = "bad version"
      response = put "/ofx/#{ofx.ofx_id}", params
      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Compare Old/New OFX Configuration"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this OFX configuration, please confirm changes"
    end
  end

  context "DELETE /ofx/:id" do
    it "deletes the ofx" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)

      response = delete "/ofx/#{ofx.ofx_id}", {
        _token: PiggyBank::App.token,
        version: ofx.version,
      }
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/ofxs"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "OFX configuration deleted."
    end
  end

  context "DELETE /ofx/:id with invalid token" do
    it "politely refuses to delete" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)
      params = update_params ofx
      params["_token"] = "bad penny"
      response = delete "/ofx/#{ofx.ofx_id}", params
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Delete OFX Configuration?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
    end
  end

  context "DELETE /ofx/:id with version mismatch" do
    it "politely refuses to delete" do
      assets = PiggyBank::Account.find(name: "Assets")
      ofx = PiggyBank::Ofx.find(account_id: assets.account_id)
      params = update_params ofx
      params[:version] = "bad version"
      response = delete "/ofx/#{ofx.ofx_id}", params

      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Delete OFX Configuration?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this OFX configuration, please re-confirm delete"
    end
  end
end

# ZZZ: pass list of ofxs

# ZZZ: GET /ofx = new ofx form
# ZZZ: POST /ofx = create ofx
# ZZZ: POST /ofx CSRF protection

# ZZZ: GET /ofx/:id = view ofx
# ZZZ: GET /ofx/:id?edit = edit ofx form
# ZZZ: PUT /ofx/:id = update ofx
# ZZZ: PUT /ofx/:id CSRF prevention
# ZZZ: PUT /ofx/:id version mismatch

# ZZZ: GET /ofx/:id?delete = confirm delete form
# ZZZ: DELETE /ofx/:id = delete ofx
# ZZZ: DELETE /ofx/:id CSRF prevention
# ZZZ: DELETE /ofx/:id version mismatch
