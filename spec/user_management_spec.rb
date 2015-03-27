ENV['RACK_ENV'] = 'test'

require 'json'
require 'rspec'
require 'rack/test'

require_relative '../lib/UserManagement/user_management_system'
require_relative '../lib/UserManagement/middleware'

describe 'User Management' do
  include Rack::Test::Methods

  let(:app) {
    Rack::Builder.new {
      map "/user" do
        use Middleware
        run UserManagementSystem
      end
    }
  }

  it 'should authenticate user' do
    basic_authorize("wanda", "partyhard2000")
    get '/user'
    expect(last_response.status).to eq(200)
  end

  it 'should not authenticate user' do
    basic_authorize("wanda", "partyharder3000")
    get '/user'
    expect(last_response.status).to eq(403)
  end
end