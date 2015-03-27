ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'

require_relative '../lib/LocationManagement/location_management_system'

describe 'Location Management System' do
  include Rack::Test::Methods

  let(:app) {
    Rack::Builder.new {
      map "/locations" do
        run LocationManagementSystem
      end
    }
  }
  let(:params) {
    {
      name: "Office Alexanderstraße",
      address: "Alexanderstraße 45, 33853 Bielefeld, Germany"
    }
  }

  let(:headers) {
    {
      "ACCEPT" => "application/vnd.project-v1+json"
    }
  }

  it 'should create locations' do
    post '/locations', params, headers
    expect(last_response.status).to eq(201)
  end

  it 'should get locations' do
    get '/locations'

    expected = [
      { 
        "name" => "Office Alexanderstraße",
        "address" => "Alexanderstraße 45, 33853 Bielefeld, Germany",
        "id" => 1
      }
    ]

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to eq(expected)
  end



  it 'should delete locations' do
    delete '/locations/1'
    expect(last_response).to be_ok
  end

end
