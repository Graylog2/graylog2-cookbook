require 'faraday'

action :create do
  resource_input new_resource.input if new_resource.input
  connection = Faraday.new(url: node[:graylog2][:rest][:listen_uri]) do |faraday|
    faraday.basic_auth(node[:graylog2][:rest][:admin_access_token], 'token')
    faraday.adapter(Faraday.default_adapter)
  end
  
  if new_resource.input
    response = connection.post('/system/inputs', resource_input, { :'Content-Type' => 'application/json' })
    Chef::Log.debug("Graylog2 API response: #{response.status}")
  elsif not node[:graylog2][:inputs].nil?
    node[:graylog2][:inputs].each do |input|
      response = connection.post('/system/inputs', input, { :'Content-Type' => 'application/json' })
      Chef::Log.debug("Graylog2 API response: #{response.status}")
    end
  end
end
