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

template "/etc/graylog2-radio.conf" do
  source "graylog2.radio.conf.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-radio]'
end

template "/etc/graylog2/radio/log4j.xml" do
  source "graylog2.radio.log4j.xml.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-radio]'
end
