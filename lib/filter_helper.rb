module FilterHelper
	protected
	def self.auth_helper(client, env)
		return client.get("/user", headers: set_headers(env))
	end

	def self.set_headers(env)
		headers = {}
		headers["AUTHORIZATION"] = env["HTTP_AUTHORIZATION"] if env["HTTP_AUTHORIZATION"]
		headers["ACCEPT"] = env["HTTP_ACCEPT"] if env["HTTP_ACCEPT"]
		headers
	end
end