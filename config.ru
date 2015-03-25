#\ -p 9292

require 'rubygems'
require 'bundler'
Bundler.require

require File.expand_path('../lib/UserManagement/user_management_system', __FILE__)
require File.expand_path('../lib/UserManagement/middleware', __FILE__)
require File.expand_path('../lib/Reports/reports_system', __FILE__)
require File.expand_path('../lib/LocationManagement/location_management_system', __FILE__)
require File.expand_path('../lib/ItemTracking/item_tracking_system', __FILE__)


app = Rack::Builder.new {
    map '/user' do
        use Middleware
        run UserManagementSystem.new
    end

    map '/items' do
        run ItemTrackingSystem.new
    end

    map '/locations' do
        run LocationManagementSystem.new
    end

    map '/reports' do
        run ReportsSystem.new
    end
}

run app