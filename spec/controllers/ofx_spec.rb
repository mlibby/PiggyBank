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

  # context "GET /ofx" do
  #   it "gives a new API Key form" do
  #     response = get "/ofx"

  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag "h1", text: "New API Key"
  #     expect(response.body).to have_tag(
  #       "form",
  #       with: {
  #         method: "POST",
  #         action: "/ofx",
  #       },
  #     )
  #   end
  # end

  # def create_params
  #   ofx = {
  #     _token: PiggyBank::App.token,
  #     description: "yahoo",
  #     value: "xyz123"
  #   }
  # end

  # context "POST /ofx" do
  #   it "redirects to /ofxs" do
  #     response = post "/ofx", create_params
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/ofxs"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "API key created."
  #   end
  # end

  # context "POST /ofx with invalid token" do
  #   it "politely refuses to create" do
  #     params = create_params
  #     params[:_token] = "bad token"
  #     response = post "/ofx", params

  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "New API Key"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
  #   end
  # end

  # context "GET /ofx/:id" do
  #   it "shows the API key" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     response = get "/ofx/#{ofx.ofx_id}"

  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag "h1", text: "API Key 'alphavantage'"
  #   end
  # end

  # context "GET /ofx/:id?edit" do
  #   it "has an edit form" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     response = get "/ofx/#{ofx.ofx_id}?edit"
  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag "h1", text: "Edit API Key"
  #     expect(response.body).to have_tag("form", with: { method: "POST" }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: ofx.version }
  #     end
  #   end
  # end

  # context "GET /ofx/:id?delete" do
  #   it "has a delete confirmation form" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     response = get "/ofx/#{ofx.ofx_id}?delete"
  #     expect(response.body).to include "Delete API Key?"
  #     expect(response.status).to eq 200
  #     expect(response.body).to have_tag(
  #       "form",
  #       with: {
  #         method: "POST",
  #         action: "/ofx/#{ofx.ofx_id}",
  #       },
  #     ) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: ofx.version }
  #     end
  #   end
  # end

  # def update_params(existing)
  #   {
  #     _token: PiggyBank::App.token,
  #     description: "betavantage",
  #     value: "zzz000",
  #     version: existing.version,
  #   }
  # end

  # context "PUT /ofx/:id with valid params" do
  #   it "updates the DB" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     response = put "/ofx/#{ofx.ofx_id}", update_params(ofx)

  #     expect(response.status).to eq 200

  #     ofx = PiggyBank::Ofx.find(ofx_id: ofx.ofx_id)

  #     expect(ofx.description).to eq "betavantage"
  #     expect(ofx.value).to eq "zzz000"
  #   end
  # end

  # context "PUT /ofx/:id with invalid token" do
  #   it "politely refuses to update" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     params = update_params ofx
  #     params[:_token] = "bad token"
  #     response = put "/ofx/#{ofx.ofx_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Edit API Key"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
  #   end
  # end

  # context "PUT /ofx/:id with version mismatch" do
  #   it "politely refuses to update" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     params = update_params ofx
  #     params[:version] = "bad version"
  #     response = put "/ofx/#{ofx.ofx_id}", params
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Compare Old/New API Key"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this API key, please confirm changes"
  #   end
  # end

  # context "DELETE /ofx/:id" do
  #   it "deletes the ofx" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     response = delete "/ofx/#{ofx.ofx_id}", {
  #       _token: PiggyBank::App.token,
  #       version: ofx.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/ofxs"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "API key deleted."
  #   end
  # end

  # context "DELETE /ofx/:id with invalid token" do
  #   it "politely refuses to delete" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     params = update_params ofx
  #     params["_token"] = "bad penny"
  #     response = delete "/ofx/#{ofx.ofx_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete API Key?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /ofx/:id with version mismatch" do
  #   it "politely refuses to delete" do
  #     ofx = PiggyBank::Ofx.find(description: "alphavantage")
  #     params = update_params ofx
  #     params[:version] = "bad version"
  #     response = delete "/ofx/#{ofx.ofx_id}", params

  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete API Key?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this API key, please re-confirm delete"
  #   end
  # end
end

# TODO: pass list of ofxs

# TODO: GET /ofx = new ofx form
# TODO: POST /ofx = create ofx
# TODO: POST /ofx CSRF protection

# TODO: GET /ofx/:id = view ofx
# TODO: GET /ofx/:id?edit = edit ofx form
# TODO: PUT /ofx/:id = update ofx
# TODO: PUT /ofx/:id CSRF prevention
# TODO: PUT /ofx/:id version mismatch

# TODO: GET /ofx/:id?delete = confirm delete form
# TODO: DELETE /ofx/:id = delete ofx
# TODO: DELETE /ofx/:id CSRF prevention
# TODO: DELETE /ofx/:id version mismatch
