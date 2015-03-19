require 'grape'
require_relative '../filter_helper'

class ItemTrackingSystem < Grape::API
	version 'v1', using: :header, vendor: 'project'
	format :json

	items = []

	id = 1
	size = items.length


	resource :items  do
		get do
			items
		end

		desc "create new location parameters"
		params do
			requires :name, type: String
			requires :location, type: Integer
		end
		post do
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
	end

	resource :item do
		delete ":id" do
			items.delete_if { | l | l[:id] == params["id"].to_i }
			if items.length < size
				# Successfully deleted item
				size = items.length
				status 200
			else
				# Item not found
				status 404
			end
		end
	end
end