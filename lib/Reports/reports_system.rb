require 'grape'
require_relative './reports_client'


class ReportsSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json


	resource :reports do
		get "by-location" do
			headers = {}
			headers["AUTHORIZATION"] = env["HTTP_AUTHORIZATION"] if env["HTTP_AUTHORIZATION"]
			headers["ACCEPT"] = env["HTTP_ACCEPT"] if env["HTTP_ACCEPT"]
			response = ReportsClient.get("http://localhost:9292/user", headers: headers).body
			p "Response: #{response}"
		end
	end
end
