chef_gem 'mongo' do
  compile_time false if respond_to?(:compile_time)
  version '1.12.3'
end
chef_gem 'faraday' do
  compile_time false if respond_to?(:compile_time)
  version '0.9.0'
end
chef_gem 'faraday-conductivity' do
  compile_time false if respond_to?(:compile_time)
  version '0.3.0'
end

Chef::Log.info 'Wait until the Graylog2 API is ready'
graylog2_api_check 'api_check'
Chef::Log.info 'Graylog2 API available, resume provision'

graylog2_token 'admin'
graylog2_inputs 'inputs_from_attributes'
graylog2_streams 'streams_from_attributes'
graylog2_dashboards 'dashboards_from_attributes'
