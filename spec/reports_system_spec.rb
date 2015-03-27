ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'
#require "capybara"

OUTER_APP, OPTIONS = Rack::Builder.parse_file('./config.ru')

require_relative '../lib/UserManagement/user_management_system'
require_relative '../lib/ItemTracking/item_tracking_system'
require_relative '../lib/LocationManagement/location_management_system'
require_relative '../lib/Reports/reports_system'
require_relative '../lib/UserManagement/middleware'

describe 'Reports System' do
  include Rack::Test::Methods

  let(:app) {
    OUTER_APP
  }

  # starts all services with the config file
  before(:all) do
    @pid = Process.fork do
      Dir.chdir(File.expand_path("../../", __FILE__))
      exec "rackup -o 0.0.0.0 config.ru"
    end
    sleep 3
  end

  # kills the LocationManagementAPI and ItemTrackingAPI by console commands
  after(:all) do
    Process.kill "INT", @pid
    Process.wait
  end

  let(:location) {
    {
      name: "Office Alexanderstraße",
      address: "Alexanderstraße 45, 33853 Bielefeld, Germany"
    }
  }

  let(:item) {
    {
      name: "Christians PC",
      location: 1
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
        "name" => "Office Alexanderstraße",
        "address" => "Alexanderstraße 45, 33853 Bielefeld, Germany",
        "id" => 1,
        "items" => [
          {
            "name" => "Christians PC",
            "location" => 1,
            "id" => 1
          }
        ]
      }
    ]
  }

  before(:each) do
    basic_authorize("wanda", "partyhard2000")
  end
  

  it 'should get locations and their items' do
    post '/locations', location, headers
    post '/items', item, headers
    post '/items', item, headers
    get '/reports/by-location'
    expect(last_response.status).to eq(200)
  end
end