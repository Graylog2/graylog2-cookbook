package "graylog2-radio" do
  action :install
  version node.graylog2[:radio][:version]
  if platform?('debian')
    options "--force-yes"
  end
end

directory "/var/run/graylog2-radio" do
  action :create
  owner 'graylog2-radio'
  group node.graylog2[:group]
end

service "graylog2-radio" do
  action :nothing
  supports :status => true, :restart => true
  if platform?('ubuntu')
    provider Chef::Provider::Service::Upstart
  end
end

default_server_uri = "http://#{node['ipaddress']}:12900/"
default_rest_listen_uri = "http://#{node['ipaddress']}:12950/"

template "/etc/graylog2-radio.conf" do
  source "graylog2.radio.conf.erb"
  owner 'root'
  mode 0644
  variables({
    :radio_server_uri => node.graylog2[:radio][:server_uri] || default_server_uri,
    :radio_rest_listen_uri => node.graylog2[:radio][:rest][:listen_uri] || default_rest_listen_uri
  })

  notifies :restart, 'service[graylog2-radio]', node.graylog2[:restart].to_sym
end

if platform_family?("debian")
  args_file = "/etc/default/graylog2-radio"
elsif platform_family?("rhel")
  args_file = "/etc/sysconfig/graylog2-radio"
else
  Chef::Log.error "Platform not supported."
end

template args_file do
  source "graylog2.radio.default.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-radio]', node.graylog2[:restart].to_sym
end

template "/etc/graylog2/radio/log4j.xml" do
  source "graylog2.radio.log4j.xml.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-radio]', node.graylog2[:restart].to_sym
end
