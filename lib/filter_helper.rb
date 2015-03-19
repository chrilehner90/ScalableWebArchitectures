module FilterHelper
	protected
	def self.auth_helper(client, env)
		headers = {}
		headers["AUTHORIZATION"] = env["HTTP_AUTHORIZATION"] if env["HTTP_AUTHORIZATION"]
		headers["ACCEPT"] = env["HTTP_ACCEPT"] if env["HTTP_ACCEPT"]
		return client.get("http://localhost:9292/user", headers: headers)
	end
end