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

  # context "GET /api_key" do
  #   it "gives a new Transaction form" do
  #     response = get "/api_key"

  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag "h1", text: "New Transaction"
  #     expect(response.body).to have_tag(
  #       "form",
  #       with: {
  #         method: "POST",
  #         action: "/api_key",
  #       },
  #     )
  #   end
  # end

  # def create_params
  #   equity = PiggyBank::Account.find(name: "Equity")
  #   asset = PiggyBank::Account.find(name: "Assets")
  #   api_key = {
  #     _token: PiggyBank::App.token,
  #     post_date: "2021-01-28",
  #     number: 1,
  #     description: "opening balance",
  #     splits: [
  #       {
  #         account_id: equity.account_id,
  #         memo: "",
  #         amount: -12.34,
  #         value: -12.34,
  #       },
  #       {
  #         account_id: asset.account_id,
  #         memo: "",
  #         amount: 12.34,
  #         value: 12.34,
  #       },
  #     ],
  #   }
  # end

  # context "POST /api_key" do
  #   it "redirects to /api_keys" do
  #     response = post "/api_key", create_params
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/api_keys"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "Transaction created."
  #   end
  # end

  # context "POST /api_key with invalid token" do
  #   it "politely refuses to create" do
  #     params = create_params
  #     params[:_token] = "bad token"
  #     response = post "/api_key", params

  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "New Transaction"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
  #   end
  # end

  # context "GET /api_key/:id" do
  #   it "shows the transaction" do
  #     api_key = PiggyBank::ApiKey.first
  #     response = get "/api_key/#{api_key.api_key_id}"

  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag "h1", text: "Transaction"
  #   end
  # end

  # context "GET /api_key/:id?edit" do
  #   it "has an edit form" do
  #     api_key = PiggyBank::ApiKey.first
  #     response = get "/api_key/#{api_key.api_key_id}?edit"
  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag "h1", text: "Edit Transaction"
  #     expect(response.body).to have_tag("form", with: { method: "POST" }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: api_key.version }
  #     end
  #   end
  # end

  # context "GET /api_key/:id?delete" do
  #   it "has a delete confirmation form" do
  #     api_key = PiggyBank::ApiKey.first
  #     response = get "/api_key/#{api_key.api_key_id}?delete"
  #     expect(response.body).to include "Delete Transaction?"
  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag(
  #       "form",
  #       with: {
  #         method: "POST",
  #         action: "/api_key/#{api_key.api_key_id}",
  #       },
  #     ) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: api_key.version }
  #     end
  #   end
  # end

  # def update_params(existing)
  #   {
  #     _token: PiggyBank::App.token,
  #     post_date: "2021-01-25",
  #     number: 4,
  #     description: "Bitz Booop Beep",
  #     version: existing.version,
  #     splits: [
  #       {
  #         memo: "foo",
  #         amount: -45.67,
  #         value: -45.67,
  #       },
  #       {
  #         memo: "bar",
  #         amount: 45.67,
  #         value: 45.67,
  #       },
  #     ],
  #   }
  # end

  # context "PUT /api_key/:id with valid params" do
  #   it "updates the DB" do
  #     api_key = PiggyBank::ApiKey.first
  #     response = put "/api_key/#{api_key.api_key_id}", update_params(api_key)

  #     expect(response.status).to eq 200

  #     api_key = PiggyBank::ApiKey.find(api_key_id: api_key.api_key_id)

  #     expect(api_key.description).to eq "Bitz Booop Beep"
  #   end
  # end

  # context "PUT /api_key/:id with invalid token" do
  #   it "politely refuses to update" do
  #     api_key = PiggyBank::ApiKey.first
  #     params = update_params api_key
  #     params[:_token] = "bad token"
  #     response = put "/api_key/#{api_key.api_key_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Edit Transaction"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
  #   end
  # end

  # context "PUT /api_key/:id with version mismatch" do
  #   it "politely refuses to update" do
  #     api_key = PiggyBank::ApiKey.first
  #     params = update_params api_key
  #     params[:version] = "bad version"
  #     response = put "/api_key/#{api_key.api_key_id}", params
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Compare Old/New Transaction"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this api_key, please confirm changes"
  #   end
  # end

  # context "DELETE /api_key/:id" do
  #   it "deletes the api_key" do
  #     api_key = PiggyBank::ApiKey.first
  #     response = delete "/api_key/#{api_key.api_key_id}", {
  #       _token: PiggyBank::App.token,
  #       version: api_key.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/api_keys"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "Transaction deleted."
  #   end
  # end

  # context "DELETE /api_key/:id with invalid token" do
  #   it "politely refuses to delete" do
  #     api_key = PiggyBank::ApiKey.first
  #     params = update_params api_key
  #     params["_token"] = "bad penny"
  #     response = delete "/api_key/#{api_key.api_key_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete Transaction?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /api_key/:id with version mismatch" do
  #   it "politely refuses to delete" do
  #     api_key = PiggyBank::ApiKey.first
  #     params = update_params api_key
  #     params[:version] = "bad version"
  #     response = delete "/api_key/#{api_key.api_key_id}", params

  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete Transaction?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this api_key, please re-confirm delete"
  #   end
  # end
end

# TODO: pass list of api_keys

# TODO: GET /api_key = new api_key form
# TODO: POST /api_key = create api_key
# TODO: POST /api_key CSRF protection

# TODO: GET /api_key/:id = view api_key
# TODO: GET /api_key/:id?edit = edit api_key form
# TODO: PUT /api_key/:id = update api_key
# TODO: PUT /api_key/:id CSRF prevention
# TODO: PUT /api_key/:id version mismatch

# TODO: GET /api_key/:id?delete = confirm delete form
# TODO: DELETE /api_key/:id = delete api_key
# TODO: DELETE /api_key/:id CSRF prevention
# TODO: DELETE /api_key/:id version mismatch
