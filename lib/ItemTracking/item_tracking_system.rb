require 'grape'
require_relative '../filter_helper'
require_relative '../client'

class ItemTrackingSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	items = []

	id = 1
	size = items.length

	helpers do
		def authenticate!
			status = FilterHelper.auth_helper(Client, env)
			error!("403 Forbidden", status.code) unless status.code == 200
		end
	end

	desc "return items"
	get do
		authenticate!
		items
	end

	desc "location parameters"
	params do
		requires :name, type: String
		requires :location, type: Integer
	end
	desc "create new location"
	post do
		authenticate!
		new_item = {
			"name": params["name"],
			"location": params["location"],
			"id": id
		}
		id += 1
		size += 1
		status 201
		items.push new_item
		new_item
	end

	desc "delete location by id"
	delete ":id" do
		authenticate!
		items.delete_if { | l | l[:id] == params["id"].to_i }
		if items.length < size
			# Successfully deleted item
			id -= 1
			size = items.length
			status 200
		else
			# Item not found
			status 404
		end
	end


end