action :create do
  require 'json'
  require 'faraday'

  resource_input new_resource.input if new_resource.input
  rest_uri = node[:graylog2][:rest][:listen_uri] || "http://#{node['ipaddress']}:12900/"
  connection = Faraday.new(url: rest_uri) do |faraday|
    faraday.basic_auth(node[:graylog2][:rest][:admin_access_token], 'token')
    faraday.adapter(Faraday.default_adapter)
  end
 
  if new_resource.input
    inputs = Array.new(resource_input)
  else
    inputs = node[:graylog2][:inputs]
  end

  if not inputs.nil?
    inputs.each do |input|
      parsed_input = JSON.parse(input)

      response = ""
      tries    = 10
      begin
        response = connection.get('/system/inputs')
      rescue
        sleep 1
        unless (tries -= 1).zero?
          retry
        else
          Chef::Application.fatal!("Can not access Graylog2 API")
        end
      end

      if !response.body.nil?
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
