require 'grape'
require_relative '../filter_helper'
require_relative '../client'


class ReportsSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	get "by-location" do
		response = FilterHelper.auth_helper(Client, env)
		if response.code == 200
			locations = JSON.parse(Client.get("/locations").body)
			items = JSON.parse(Client.get("/items").body)
			locations.each do | location |
				location["items"] = items.select { |item| item["location"] == location["id"] }
			end
			locations
		else
			status 403
		end
	end
end
