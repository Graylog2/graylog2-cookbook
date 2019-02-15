# Override attributes from data bag's "server" section
secrets = {}
begin
  secrets = data_bag_item(node['graylog2']['secrets_data_bag'], node['graylog2']['secrets_data_bag_item'])['server']
rescue
  Chef::Log.debug 'Can not load server secrets from databag'
end
password_secret = secrets['password_secret'] || node['graylog2']['password_secret']
root_password_sha2 = secrets['root_password_sha2'] || node['graylog2']['root_password_sha2']
raise('No password_secret set, either set it via an attribute or in the encrypted data bag in secrets.graylog') unless password_secret
raise('No root_password_sha2 set, either set it via an attribute or in the encrypted data bag in secrets.graylog') unless root_password_sha2

# Search ES cluster
if node['graylog2']['elasticsearch']['node_search_query'] && node['graylog2']['elasticsearch']['node_search_attribute']
  nodes = search_for_nodes(node['graylog2']['elasticsearch']['node_search_query'], node['graylog2']['elasticsearch']['node_search_attribute'])
  Chef::Log.debug("Found elasticsearch nodes at #{nodes.join(', ').inspect}")
  node.default['graylog2']['elasticsearch']['hosts'] = nodes.map { |ip| node.default['graylog2']['elasticsearch']['node_search_protocol'] + '://' + ip + ':9200' }.join(',')
end

package 'tzdata-java' if node['graylog2']['server']['install_tzdata_java']

package 'graylog-server' do
  action :install
  version node['graylog2']['server']['version']
  options '--no-install-recommends --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"' if platform_family?('debian')
  notifies :restart, 'service[graylog-server]', node['graylog2']['restart'].to_sym
end

package 'graylog-enterprise-plugins' do
  action :install
  version node['graylog2']['server']['version']
  notifies :restart, 'service[graylog-server]', node['graylog2']['restart'].to_sym
  only_if { node['graylog2']['install_enterprise_plugins'] }
end

package 'graylog-integrations-plugins' do
  action :install
  version node['graylog2']['server']['version']
  notifies :restart, 'service[graylog-server]', node['graylog2']['restart'].to_sym
  only_if { node['graylog2']['install_integrations_plugins'] }
end

ruby_block 'create node-id if needed' do
  block do
    File.write(node['graylog2']['node_id_file'], SecureRandom.uuid)
  end
  not_if { ::File.exist?(node['graylog2']['node_id_file']) }
end

directory '/var/run/graylog' do
  action :create
  owner node['graylog2']['server']['user']
  group node['graylog2']['server']['group']
end

directory File.dirname(node['graylog2']['server']['log_file']) do
  action :create
  recursive true
  owner node['graylog2']['server']['user']
  group node['graylog2']['server']['group']
end

service 'graylog-server' do
  action [:enable, :start]
  restart_command node['graylog2']['server']['override_restart_command'] if node['graylog2']['server']['override_restart_command']
end

file '/etc/init/graylog-server.override' do
  action :delete
  only_if { node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 9.10 }
end

is_master = node['graylog2']['is_master']
is_master = node['graylog2']['ip_of_master'] == node['ipaddress'] if is_master.nil?

template '/etc/graylog/server/server.conf' do
  source 'graylog.server.conf.erb'
  owner 'root'
  group node['graylog2']['server']['group']
  mode '0640'
  variables(
    :is_master             => is_master,
    :password_secret       => password_secret,
    :root_password_sha2    => root_password_sha2,
    :http_tls_key_password => secrets['http_tls_key_password'] || node['graylog2']['http']['tls_key_password'],
    :mongodb_uri           => secrets['mongodb_uri'] || node['graylog2']['mongodb']['uri'],
    :transport_email_auth_password => secrets['transport_email_auth_password'] || node['graylog2']['transport_email_auth_password']
  )
  notifies :restart, 'service[graylog-server]', node['graylog2']['restart'].to_sym
end

if platform_family?('debian')
  args_file = '/etc/default/graylog-server'
elsif platform_family?('rhel', 'amazon')
  args_file = '/etc/sysconfig/graylog-server'
else
  Chef::Log.error 'Platform not supported.'
end

template args_file do
  source 'graylog.server.default.erb'
  owner 'root'
  mode '0644'
  notifies :restart, 'service[graylog-server]', node['graylog2']['restart'].to_sym
end

template '/etc/graylog/server/log4j2.xml' do
  source 'graylog.server.log4j2.xml.erb'
  owner 'root'
  group node['graylog2']['server']['group']
  mode '0640'
  notifies :restart, 'service[graylog-server]', node['graylog2']['restart'].to_sym
end
