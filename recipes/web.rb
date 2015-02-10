if not node.graylog2[:web][:secret]
  begin
    secrets = Chef::EncryptedDataBagItem.load("secrets", "graylog")
    node.set[:graylog2][:web][:secret] = secrets["web"]["secret"]
  rescue
    Chef::Application.fatal!("No password_secret set, either set it via an attribute or in the encrypted data bag in secrets.graylog")
  end
end

package "graylog-web" do
  action :install
  version node.graylog2[:web][:version]
  if platform?('debian')
    options "--force-yes"
  end
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end

service "graylog-web" do
  action :nothing
  supports :status => true, :restart => true
  restart_command node.graylog2[:web][:override_restart_command] if node.graylog2[:web][:override_restart_command]
  if platform?('ubuntu')
    provider Chef::Provider::Service::Upstart
  end
end

default_backend_uri = "http://#{node['ipaddress']}:12900/"

template "/etc/graylog/web/web.conf" do
  source "graylog.web.conf.erb"
  owner 'root'
  mode 0644
  variables({
    :web_server_backends => node.graylog2[:web][:server_backends] || default_backend_uri
  })
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end

if platform_family?("debian")
  args_file = "/etc/default/graylog-web"
elsif platform_family?("rhel")
  args_file = "/etc/sysconfig/graylog-web"
else
  Chef::Log.error "Platform not supported."
end

if node.graylog2[:web][:server_search_query] and node.graylog2[:web][:search_node_attribute]
  nodes = search_for_nodes(node.graylog2[:web][:server_search_query], node.graylog2[:web][:search_node_attribute])
  Chef::Log.debug("Found Graylog server nodes at #{nodes.join(', ').inspect}")
  node.set[:graylog2][:web][:discovery_zen_ping_unicast_hosts] = nodes.join(',')
end

template args_file do
  source "graylog.web.default.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end

template "/etc/graylog/web/logback.xml" do
  source "graylog.web.logback.xml.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog-web]', node.graylog2[:restart].to_sym
end
