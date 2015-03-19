#\ -p 9595

require 'rubygems'
require 'bundler'
Bundler.require

require File.expand_path('../lib/ItemTracking/item_tracking_system', __FILE__)


run ItemTrackingSystem.new