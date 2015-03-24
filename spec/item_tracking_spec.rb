ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'

require_relative '../lib/ItemTracking/item_tracking_system'

describe 'Item Management System' do
  include Rack::Test::Methods

  def app
    ItemTrackingSystem.new
  end

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
    delete '/item/1'
    expect(last_response).to be_ok
  end

end
