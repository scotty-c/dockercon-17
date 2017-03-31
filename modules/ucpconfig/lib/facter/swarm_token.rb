require 'net/http'
require 'uri'
require 'json'
require 'openssl'
require 'facter'

Facter.add('swarm_token') do
  setcode do

    def auth_token
      uri = URI.parse("https://172.17.10.101/auth/login")
      request = Net::HTTP::Post.new(uri.to_s)
      request.body = JSON.dump({
	      "username" => "admin",
	         "password" => "orca4307"
      })

      req_options = {
  	      use_ssl: uri.scheme == "https",
	      verify_mode: OpenSSL::SSL::VERIFY_NONE
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	        http.request(request)	    
        end
      data = JSON.parse(response.body)['auth_token']
      return data
    end

    def swarm_token
      uri = URI.parse("https://172.17.10.101/v1.24/swarm")
      request = Net::HTTP::Get.new(uri.to_s)
      request["Authorization"] = "#{auth_token}"

      req_options = {
	        use_ssl: uri.scheme == "https",
	        verify_mode: OpenSSL::SSL::VERIFY_NONE,
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
 	        http.request(request)
        end
      data = JSON.parse(response.body)['JoinTokens']['Worker']
  
      return data
    end
   swarm_token
  end
end  
