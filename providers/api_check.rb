action :create do
  require 'json'
  require 'faraday'
  require 'faraday/conductivity'

  NO_RETRIES = 300 # 5 minutes, waiting a second to retry

  rest_uri = node[:graylog2][:rest][:listen_uri] || "http://#{node['ipaddress']}:12900/"
  connection = Faraday.new(url: rest_uri) do |faraday|
    faraday.adapter(Faraday.default_adapter)
    faraday.use :repeater, retries: NO_RETRIES, mode: :one
    faraday.response :selective_errors, on: (400...600)
  end

  open_connection_retries = 0

  begin
    response = connection.get('/system/lbstatus')
    if !response.success?
      raise Exception "Response was not successful"
    end
  rescue Exception
    open_connection_retries += 1
    if open_connection_retries >= NO_RETRIES
      Chef::Application.fatal!("Couldn't connect to the Graylog2 API #{rest_uri}")
    end
    sleep 1
    retry
  end
end

