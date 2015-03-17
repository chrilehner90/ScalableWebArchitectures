require 'grape'
require_relative './reports_client'
require_relative '../filter_helper'


class ReportsSystem < Grape::API
	
	include FilterHelper

	version 'v1', using: :header, vendor: 'project'
	format :json

	resource :reports do
		get "by-location" do
			FilterHelper.auth_helper(env)
		end
	end
end
