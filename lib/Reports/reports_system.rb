require 'grape'
require_relative '../filter_helper'
require_relative '../client'


class ReportsSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	helpers do
		def authenticate!
			status = FilterHelper.auth_helper(Client, env)
			error!("403 Forbidden", status.code) unless status.code == 200
		end
	end

	desc "get locations and their corresponding items"
	get "by-location" do
		authenticate!	
		locations = JSON.parse(Client.get("/locations", headers: FilterHelper.set_headers(env)).body)
		items = JSON.parse(Client.get("/items", headers: FilterHelper.set_headers(env)).body)

		locations.each do | location |
			location["items"] = items.select { |item| item["location"].to_i == location["id"].to_i }
		end
		locations
	end
end
