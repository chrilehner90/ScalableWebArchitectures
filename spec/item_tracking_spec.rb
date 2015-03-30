ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'

require_relative '../lib/ItemTracking/item_tracking_system'

describe 'Item Management System' do
  include Rack::Test::Methods

  let(:app) {
    Rack::Builder.new {
      map '/items' do
        run ItemTrackingSystem
      end
    }
  }

  let(:params) {
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

  describe "authorized access" do
    before(:each) do
      basic_authorize("wanda", "partyhard2000")
    end

    it 'should create items' do
      post '/items', params, headers
      expect(last_response.status).to eq(201)
    end

    it 'should get items' do
      get '/items'

      expected = [
        { 
          "name" => "Christians PC",
          "location" => 1,
          "id" => 1
        }
      ]

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(expected)
    end



    it 'should delete an item' do
      delete '/items/1'
      expect(last_response).to be_ok
    end
  end

  describe "unauthorized access" do

    it 'should not create items' do
      post '/items', params, headers
      expect(last_response.status).to eq(403)
    end

    it 'should not get items' do
      get '/items'
      expect(last_response.status).to eq(403)
    end



    it 'should not delete an item' do
      delete '/items/1'
      expect(last_response.status).to eq(403)
    end
  end
end
