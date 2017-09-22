property :uri, String, name_property: true
property :token, String

default_action :check

action :check do
  require 'graylogapi'

  log 'Wait until the Graylog2 API is ready' do
    level :info
  end

  url = new_resource.uri || node['graylog2']['rest']['listen_uri']
  token = new_resource.token || node['graylog2']['rest']['admin_access_token']
  retries = node['graylog2']['api_client_timeout'] || 300

  graylogapi = GraylogAPI.new(base_url: url, token: token)

  begin
    graylogapi.client.request(:get, '/')
  rescue
    raise "Can't connect to the Graylog2 API #{uri}" if retries <= 0

    retries -= 1
    sleep 1
    retry
  end

  log 'Graylog2 API available, resume provision' do
    level :info
  end
end
