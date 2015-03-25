require 'grape'
require_relative '../filter_helper'

class LocationManagementSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	locations = []

	id = 1
	size = locations.length


	get do
		locations
	end

	desc "create new location parameters"
	params do
		requires :name, type: String
		requires :address, type: String
	end
	post do
		new_location = {
			"name": params["name"],
			"address": params["address"],
			"id": id
		}
		id += 1
		size += 1
		status 201
		locations.push new_location
		new_location
	end
	
	delete ":id" do
		locations.delete_if { | l | l[:id] == params["id"].to_i }
		if locations.length < size
			# Successfully deleted location
			size = locations.length
			status 200
		else
			# Location not found
			status 404
		end
	end
end