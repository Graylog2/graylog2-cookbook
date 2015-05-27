# Override attributes from data bag's "web" section
begin
  secrets = Chef::EncryptedDataBagItem.load('secrets', 'graylog')['web']
rescue
  Chef::Log.debug 'Can not merge web secrets from databag'
end
Chef::Mixin::DeepMerge.deep_merge!(secrets, node.override[:graylog2]) unless secrets.nil?
Chef::Application.fatal!('No password_secret set, either set it via an attribute or in the encrypted data bag in secrets.graylog') unless node.graylog2[:web][:secret]

package 'graylog-web' do
  action :install
  version node.graylog2[:web][:version]
  options '--force-yes' if platform?('debian')
  options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"' if node.platform_family == 'debian'
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end

service 'graylog-web' do
  action :nothing
  supports :status => true, :restart => true
  restart_command node.graylog2[:web][:override_restart_command] if node.graylog2[:web][:override_restart_command]
  provider Chef::Provider::Service::Upstart if platform?('ubuntu')
end

default_backend_uri = "http://#{node[:ipaddress]}:12900/"

template '/etc/graylog/web/web.conf' do
  source 'graylog.web.conf.erb'
  owner 'root'
  group node.graylog2[:web][:group]
  mode 0640
  variables(
    :web_server_backends => node.graylog2[:web][:server_backends] || default_backend_uri
  )
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end

if platform_family?('debian')
  args_file = '/etc/default/graylog-web'
elsif platform_family?('rhel')
  args_file = '/etc/sysconfig/graylog-web'
else
  Chef::Log.error 'Platform not supported.'
end

if node.graylog2[:web][:server_search_query] && node.graylog2[:web][:search_node_attribute]
  nodes = search_for_nodes(node.graylog2[:web][:server_search_query], node.graylog2[:web][:search_node_attribute])
  Chef::Log.debug("Found Graylog server nodes at #{nodes.join(', ').inspect}")
  node.set[:graylog2][:web][:discovery_zen_ping_unicast_hosts] = nodes.join(',')
end

template args_file do
  source 'graylog.web.default.erb'
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end

template '/etc/graylog/web/logback.xml' do
  source 'graylog.web.logback.xml.erb'
  owner 'root'
  group node.graylog2[:web][:group]
  mode 0640
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end
