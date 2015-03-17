#\ -p 9494

require 'rubygems'
require 'bundler'
Bundler.require

require File.expand_path('../lib/LocationManagement/location_management_system', __FILE__)


run LocationManagementSystem.new