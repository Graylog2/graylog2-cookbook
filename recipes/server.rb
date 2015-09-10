# Override attributes from data bag's "server" section
begin
  secrets = Chef::EncryptedDataBagItem.load(node.graylog2[:secrets_data_bag], 'graylog')['server']
rescue
  Chef::Log.debug 'Can not merge server secrets from databag'
end
Chef::Mixin::DeepMerge.deep_merge!(secrets, node.override[:graylog2]) unless secrets.nil?
Chef::Application.fatal!('No password_secret set, either set it via an attribute or in the encrypted data bag in secrets.graylog') unless node.graylog2[:password_secret]
Chef::Application.fatal!('No root_password_sha2 set, either set it via an attribute or in the encrypted data bag in secrets.graylog') unless node.graylog2[:root_password_sha2]

# Search ES cluster
if node.graylog2[:elasticsearch][:unicast_search_query] && node.graylog2[:elasticsearch][:search_node_attribute]
  nodes = search_for_nodes(node.graylog2[:elasticsearch][:unicast_search_query], node.graylog2[:elasticsearch][:search_node_attribute])
  Chef::Log.debug("Found elasticsearch nodes at #{nodes.join(', ').inspect}")
  node.set[:graylog2][:elasticsearch][:discovery_zen_ping_unicast_hosts] = nodes.map { |ip| ip + ':9300' }.join(',')
end

package 'tzdata-java'
package 'graylog-server' do
  action :install
  version node.graylog2[:server][:version]
  options '--no-install-recommends --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"' if platform_family?('debian')
  notifies :restart, 'service[graylog-server]', node.graylog2[:restart].to_sym
end

directory '/var/run/graylog' do
  action :create
  owner node.graylog2[:server][:user]
  group node.graylog2[:server][:group]
end

service 'graylog-server' do
  action :nothing
  supports :status => true, :restart => true
  restart_command node.graylog2[:server][:override_restart_command] if node.graylog2[:server][:override_restart_command]
  provider Chef::Provider::Service::Upstart if platform?('ubuntu')
end

if node.graylog2[:ip_of_master] == node.ipaddress
  is_master = true
else
  is_master = false
end

default_rest_uri = "http://#{node[:ipaddress]}:12900/"

template '/etc/graylog/server/server.conf' do
  source 'graylog.server.conf.erb'
  owner 'root'
  group node.graylog2[:server][:group]
  mode 0640
  variables(
    :is_master          => is_master,
    :rest_listen_uri    => node.graylog2[:rest][:listen_uri] || default_rest_uri,
    :rest_transport_uri => node.graylog2[:rest][:transport_uri] || default_rest_uri
  )
  notifies :restart, 'service[graylog-server]', node.graylog2[:restart].to_sym
end

if platform_family?('debian')
  args_file = '/etc/default/graylog-server'
elsif platform_family?('rhel')
  args_file = '/etc/sysconfig/graylog-server'
else
  Chef::Log.error 'Platform not supported.'
end

template args_file do
  source 'graylog.server.default.erb'
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog-server]', node.graylog2[:restart].to_sym
end

template '/etc/graylog/server/log4j.xml' do
  source 'graylog.server.log4j.xml.erb'
  owner 'root'
  group node.graylog2[:server][:group]
  mode 0640
  notifies :restart, 'service[graylog-server]', node.graylog2[:restart].to_sym
end

template '/etc/graylog-elasticsearch.yml' do
  source 'graylog.server.elasticsearch.yml.erb'
  owner 'root'
  group node.graylog2[:server][:group]
  mode 0640
  notifies :restart, 'service[graylog-server]', node.graylog2[:restart].to_sym
end
