require 'grape'

class UserManagementSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	get do
		status 200
	end
end