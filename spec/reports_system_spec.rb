ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'

require_relative '../lib/UserManagement/user_management_system'
require_relative '../lib/ItemTracking/item_tracking_system'
require_relative '../lib/LocationManagement/location_management_system'
require_relative '../lib/Reports/reports_system'
require_relative '../lib/UserManagement/middleware'

describe 'Reports System' do
  include Rack::Test::Methods

  let(:app) {
    Rack::Builder.new {
        map '/reports' do
            run ReportsSystem
        end
    }
  }

  let(:headers) {
    {
      "ACCEPT" => "application/vnd.project-v1+json"
    }
  }

  let(:expected) {
    [
      {
        "name" => "Test Location",
        "address" => "Test Strasse 1",
        "id" => 1,
        "items" => [
          {
            "name" => "Test PC",
            "location" => 1,
            "id" => 1
          },
          {
            "name" => "Test PC",
            "location" => 1,
            "id" => 2
          }
        ]
      }
    ]
  }

  describe "authorized access" do
    before(:each) do
      basic_authorize("wanda", "partyhard2000")
    end

    it 'should get locations and their items' do
      system("httparty -H accept:application/vnd.project-v1+json -u wanda:partyhard2000 -a post -d 'name=Test Location&address=Test Strasse 1' http://localhost:9292/locations")
      system("httparty -H accept:application/vnd.project-v1+json -u wanda:partyhard2000 -a post -d 'name=Test PC&location=1' http://localhost:9292/items")
      system("httparty -H accept:application/vnd.project-v1+json -u wanda:partyhard2000 -a post -d 'name=Test PC&location=1' http://localhost:9292/items")
      get '/reports/by-location'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq(expected)
    end
  end

  describe "unauthorized access" do
    it 'should not get locations and their items' do
      get '/reports/by-location'
      expect(last_response.status).to eq(403)
    end
  end
end