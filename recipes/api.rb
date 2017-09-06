package 'gcc' if platform_family?('rhel', 'amazon')

chef_gem 'mongo' do
  compile_time false
  version '~> 2'
end

chef_gem 'graylogapi' do
  compile_time false
  version '~> 1'
end

token = node['graylog2']['rest']['admin_access_token']
Chef::Application.fatal! 'You should set admin_access_token attribute' if token.nil?
graylog2_admin_token token
