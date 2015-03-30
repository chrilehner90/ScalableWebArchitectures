require 'grape'
require_relative '../filter_helper'
require_relative '../client'

class LocationManagementSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	locations = []

	id = 1
	size = locations.length

	helpers do
		def authenticate!
			status = FilterHelper.auth_helper(Client, env)
			error!("403 Forbidden", status.code) unless status.code == 200
		end
	end


	desc "return locations"
	get do
		authenticate!
		locations
	end

	desc "create new location parameters"
	params do
		requires :name, type: String
		requires :address, type: String
	end
	desc "create new location"
	post do
		authenticate!
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
	
	desc "delete location by id"
	delete ":id" do
		authenticate!
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