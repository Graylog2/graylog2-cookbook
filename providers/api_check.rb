action :create do
  require 'json'
  require 'faraday'
  require 'faraday/conductivity'

  NO_RETRIES = node[:graylog2][:api_client_timeout] || 300

  rest_uri = node[:graylog2][:rest][:listen_uri] || "http://#{node[:ipaddress]}:12900/"
  connection = Faraday.new(url: rest_uri) do |faraday|
    faraday.adapter(Faraday.default_adapter)
    faraday.use :repeater, retries: NO_RETRIES, mode: :one
    faraday.response :selective_errors, on: (400...600)
  end

  open_connection_retries = 0

  begin
    response = connection.get('/system/lbstatus')
    raise Exception 'Response was not successful' unless response.success?
  rescue StandardError
    open_connection_retries += 1
    if open_connection_retries >= NO_RETRIES
      Chef::Application.fatal!("Couldn't connect to the Graylog2 API #{rest_uri}")
    end
    sleep 1
    retry
  end
  new_resource.updated_by_last_action(true)
end
