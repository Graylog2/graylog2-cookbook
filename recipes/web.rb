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
