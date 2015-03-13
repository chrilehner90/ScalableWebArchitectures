#\ -p 9292

require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path('../lib/UserManagement/user_management_system', __FILE__)
require File.expand_path('../lib/UserManagement/middleware', __FILE__)


use Middleware
run UserManagementSystem.new
