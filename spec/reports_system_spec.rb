ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'
require 'httparty'

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

  let(:location) {
    {
      "name": "Test Location",
      "address": "Test Strasse 1"
    }
  }

  let(:item) {
    {
      "name": "Test PC",
      "location": 1
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

  let(:auth) {
    {
      username: "wanda",
      password: "partyhard2000"
    }
  }

  describe "authorized access" do
    before do
      basic_authorize("wanda", "partyhard2000")

      HTTParty.post('http://localhost:9292/locations', {
        body: location,
        basic_auth: auth,
        headers: headers
      })

      HTTParty.post('http://localhost:9292/items', {
        body: item,
        basic_auth: auth,
        headers: headers
      })

      HTTParty.post('http://localhost:9292/items', {
        body: item,
        basic_auth: auth,
        headers: headers
      })
    end

    after do
      HTTParty.delete('http://localhost:9292/locations/1', {
        basic_auth: auth,
        headers: headers
      })

      HTTParty.delete('http://localhost:9292/items/1', {
        basic_auth: auth,
        headers: headers
      })

      HTTParty.delete('http://localhost:9292/items/2', {
        basic_auth: auth,
        headers: headers
      })
    end

    it 'should get locations and their items' do     
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