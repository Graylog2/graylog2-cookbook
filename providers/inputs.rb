action :create do
  require 'json'
  require 'faraday'
  require 'faraday/conductivity'

  rest_uri = node[:graylog2][:rest][:listen_uri] || "http://#{node['ipaddress']}:12900/"

  Chef::Application.fatal!("You need to set an access token in order to use the API.") if node[:graylog2][:rest][:admin_access_token].nil?
  connection = Faraday.new(url: rest_uri) do |faraday|
    faraday.basic_auth(node[:graylog2][:rest][:admin_access_token], 'token')
    faraday.adapter(Faraday.default_adapter)
    faraday.use :repeater, retries: 5, mode: :one
  end
 
  if new_resource.input
    inputs = [new_resource.input]
  else
    inputs = node[:graylog2][:inputs]
  end

  if not inputs.nil?
    inputs.each do |input|
      parsed_input = JSON.parse(input)
      response = connection.get('/system/inputs')

      if response.success?
        parsed_response = JSON.parse(response.body)
        saved_inputs = parsed_response.fetch("inputs")
        if existent_input?(saved_inputs, parsed_input)
          break
        end
      end

      response = connection.post('/system/inputs', input, { :'Content-Type' => 'application/json' })
      Chef::Log.debug("Graylog2 API response: #{response.status}")
    end
  end
end

def existent_input?(saved_inputs, input)
  saved_inputs.each do |saved_input|
    message_input = saved_input.fetch("message_input")
    if message_input.fetch("title") == input.fetch("title")
      return true
    end
  end

  return false
end
