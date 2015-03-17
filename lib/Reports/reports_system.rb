require 'grape'
require_relative '../filter_helper'


class ReportsSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	resource :reports do
		get "by-location" do
			response = FilterHelper.auth_helper(env)
			if response.code == 200
				response.body
			else
				status 403
			end
		end
	end
end
