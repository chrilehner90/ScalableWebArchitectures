require 'grape'
require_relative './user_management_client'

class UserManagementSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	get '/user' do
		status 200
	end
end