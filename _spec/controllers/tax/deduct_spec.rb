# require_relative "../../spec_helper.rb"

# describe PiggyBank::App do
#   include Rack::Test::Methods

#   before(:context) do
#     seed_db
#   end

#   let(:app) { PiggyBank::App.new }

#   context "GET /tax/data/deduct" do
#     it "has a deductions form" do
#       response = get "/tax/data/deduct"
#       expect(response.status).to eq 200
#     end
#   end

#   save_params = {
#     _token: PiggyBank::App.token
#   }

#   context "POST /tax/data/deduct" do
#     it "saves deductions data" do
#         response = post "/tax/data/deduct", save_params
#         expect(response.status).to eq 302
#         location = URI(response.headers["Location"])
#         expect(location.path).to eq "/tax/data"
#         expect(flash).to have_key :success
#         expect(flash[:success]).to eq "Deduction data saved."
#       end
#   end
# end
