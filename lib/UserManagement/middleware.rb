require 'base64'

class Middleware
	def initialize(app)
		@app = app
	end

	def call(env)
		encoded_user = env['HTTP_AUTHORIZATION']
		if(!encoded_user.nil?)
			username, password = Base64.decode64(encoded_user.gsub(/^Basic /, '')).split(":")

			if username == "wanda" && password == "partyhard2000" || username == "paul" && password == "thepanther" || username == "anne" && password == "flytothemoon"
				@app.call(env)
			else
				[403, {"Content-Type" => "text/plain"}, []]
			end
		else
			[403, {"Content-Type" => "text/plain"}, []]	
		end
	end
end
