property :api_uri, [String, nil], name_property: true
property :api_token, [String, nil], default: nil

default_action :check

action :check do
  require 'graylogapi'
  extend Extensions::ApiHelper

  log 'Wait until the Graylog2 API is ready' do
    level :info
  end

  retries = node['graylog2']['api_client_timeout'] || 300

  graylogapi = GraylogAPI.new(auth_params(new_resource))

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
