require_relative "../spec_helper.rb"

describe PiggyBank do
  include Rack::Test::Methods

  let(:app) { PiggyBank.new }

  context "get /" do
    let(:response) { get "/" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Oink!" }
  end
end
