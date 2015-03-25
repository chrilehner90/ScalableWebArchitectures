require 'httparty'

class Client
  include HTTParty
  base_uri 'http://localhost:9292'
end
