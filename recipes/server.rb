package "graylog2-server" do
  action :install
  version node.graylog2[:server][:version]
  if platform?('debian')
    options "--force-yes"
  end
end

directory "/var/run/graylog2" do
  action :create
  owner node.graylog2[:user]
  group node.graylog2[:group]
end

service "graylog2-server" do
  action :nothing
  supports :status => true, :restart => true
  if platform?('ubuntu')
    provider Chef::Provider::Service::Upstart
  end
end

if node.graylog2[:ip_of_master] == node.ipaddress
  is_master = true
else
  is_master = false
end

default_rest_uri = "http://#{node['ipaddress']}:12900/"

template "/etc/graylog2.conf" do
  source "graylog2.server.conf.erb"
  owner 'root'
  mode 0644
  variables({
    :is_master          => is_master,
    :rest_listen_uri    => node.graylog2[:rest][:listen_uri] || default_rest_uri,
    :rest_transport_uri => node.graylog2[:rest][:transport_uri] || default_rest_uri
  })
  notifies :restart, 'service[graylog2-server]', node.graylog2[:restart].to_sym
end

if platform?("ubuntu", "debian")
  args_file = "/etc/default/graylog2-server"
elsif platform?("redhat", "centos", "fedora")
  args_file = "/etc/sysconfig/graylog2-server"
else
  Chef::Log.error "Platform not supported."
end

template args_file do
  source "graylog2.server.default.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-server]', node.graylog2[:restart].to_sym
end

template "/etc/graylog2/server/log4j.xml" do
  source "graylog2.server.log4j.xml.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-server]', node.graylog2[:restart].to_sym
end

template "/etc/graylog2-elasticsearch.yml" do
  source "graylog2.server.elasticsearch.yml.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-server]', node.graylog2[:restart].to_sym
end
