require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "get /api_keys" do
    it "has a list of API keys" do
      response = get "/api_keys"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "API Keys"
    end
  end

  context "GET /api_key" do
    it "gives a new API Key form" do
      response = get "/api_key"

      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "New API Key"
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/api_key",
        },
      )
    end
  end

  def create_params
    api_key = {
      _token: PiggyBank::App.token,
      description: "yahoo",
      value: "xyz123"
    }
  end

  context "POST /api_key" do
    it "redirects to /api_keys" do
      response = post "/api_key", create_params
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/api_keys"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "API key created."
    end
  end

  context "POST /api_key with invalid token" do
    it "politely refuses to create" do
      params = create_params
      params[:_token] = "bad token"
      response = post "/api_key", params

      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "New API Key"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
    end
  end

  context "GET /api_key/:id" do
    it "shows the API key" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      response = get "/api_key/#{api_key.api_key_id}"

      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "API Key 'alphavantage'"
    end
  end

  context "GET /api_key/:id?edit" do
    it "has an edit form" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      response = get "/api_key/#{api_key.api_key_id}?edit"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Edit API Key"
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
        with_tag "input", with: { name: "version", type: "hidden", value: api_key.version }
      end
    end
  end

  context "GET /api_key/:id?delete" do
    it "has a delete confirmation form" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      response = get "/api_key/#{api_key.api_key_id}?delete"
      expect(response.body).to include "Delete API Key?"
      expect(response.status).to eq 200
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/api_key/#{api_key.api_key_id}",
        },
      ) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
        with_tag "input", with: { name: "version", type: "hidden", value: api_key.version }
      end
    end
  end

  def update_params(existing)
    {
      _token: PiggyBank::App.token,
      description: "betavantage",
      value: "zzz000",
      version: existing.version,
    }
  end

  context "PUT /api_key/:id with valid params" do
    it "updates the DB" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      response = put "/api_key/#{api_key.api_key_id}", update_params(api_key)

      expect(response.status).to eq 200

      api_key = PiggyBank::ApiKey.find(api_key_id: api_key.api_key_id)

      expect(api_key.description).to eq "betavantage"
      expect(api_key.value).to eq "zzz000"
    end
  end

  context "PUT /api_key/:id with invalid token" do
    it "politely refuses to update" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      params = update_params api_key
      params[:_token] = "bad token"
      response = put "/api_key/#{api_key.api_key_id}", params
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Edit API Key"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
    end
  end

  context "PUT /api_key/:id with version mismatch" do
    it "politely refuses to update" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      params = update_params api_key
      params[:version] = "bad version"
      response = put "/api_key/#{api_key.api_key_id}", params
      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Compare Old/New API Key"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this API key, please confirm changes"
    end
  end

  context "DELETE /api_key/:id" do
    it "deletes the api_key" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      response = delete "/api_key/#{api_key.api_key_id}", {
        _token: PiggyBank::App.token,
        version: api_key.version,
      }
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/api_keys"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "API key deleted."
    end
  end

  context "DELETE /api_key/:id with invalid token" do
    it "politely refuses to delete" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      params = update_params api_key
      params["_token"] = "bad penny"
      response = delete "/api_key/#{api_key.api_key_id}", params
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Delete API Key?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
    end
  end

  context "DELETE /api_key/:id with version mismatch" do
    it "politely refuses to delete" do
      api_key = PiggyBank::ApiKey.find(description: "alphavantage")
      params = update_params api_key
      params[:version] = "bad version"
      response = delete "/api_key/#{api_key.api_key_id}", params

      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Delete API Key?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this API key, please re-confirm delete"
    end
  end
end

# ZZZ: pass list of api_keys

# ZZZ: GET /api_key = new api_key form
# ZZZ: POST /api_key = create api_key
# ZZZ: POST /api_key CSRF protection

# ZZZ: GET /api_key/:id = view api_key
# ZZZ: GET /api_key/:id?edit = edit api_key form
# ZZZ: PUT /api_key/:id = update api_key
# ZZZ: PUT /api_key/:id CSRF prevention
# ZZZ: PUT /api_key/:id version mismatch

# ZZZ: GET /api_key/:id?delete = confirm delete form
# ZZZ: DELETE /api_key/:id = delete api_key
# ZZZ: DELETE /api_key/:id CSRF prevention
# ZZZ: DELETE /api_key/:id version mismatch
