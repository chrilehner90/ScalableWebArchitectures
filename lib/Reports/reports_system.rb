require 'grape'
require_relative '../filter_helper'
require_relative '../client'


class ReportsSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	resource :reports do
		get "by-location" do
			response = FilterHelper.auth_helper(Client, env)
			if response.code == 200
				locations = Client.get("http://localhost:9494/locations")
				items = Client.get("http://localhost:9595/items")
				locations.each do | location |
					location["items"] = []
					items.each do | item |
						if(item["location"] == location["id"])
							location["items"].push item
						end
					end
				end
				locations
			else
				status 403
			end
		end
	end
end
