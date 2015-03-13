#\ -p 9393

require 'rubygems'
require 'bundler'
Bundler.require

require File.expand_path('../lib/Reports/reports_system', __FILE__)


run ReportsSystem.new