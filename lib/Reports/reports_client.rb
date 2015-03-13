require 'httparty'

class ReportsClient
  include HTTParty
  base_uri 'http://localhost:9393'
end
