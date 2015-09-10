# Override attributes from data bag's "radio" section
begin
  secrets = Chef::EncryptedDataBagItem.load(node.graylog2[:secrets_data_bag], 'graylog')['radio']
rescue
  Chef::Log.debug 'Can not merge radio secrets from databag'
end
Chef::Mixin::DeepMerge.deep_merge!(secrets, node.override[:graylog2]) unless secrets.nil?

package 'graylog-radio' do
  action :install
  version node.graylog2[:radio][:version]
  options '--no-install-recommends --force-yes' if platform_family?('debian')
end

directory '/var/run/graylog-radio' do
  action :create
  owner node.graylog2[:radio][:user]
  group node.graylog2[:radio][:group]
end

service 'graylog-radio' do
  action :nothing
  supports :status => true, :restart => true
  restart_command node.graylog2[:radio][:override_restart_command] if node.graylog2[:radio][:override_restart_command]
  provider Chef::Provider::Service::Upstart if platform?('ubuntu')
end

default_server_uri = "http://#{node[:ipaddress]}:12900/"
default_rest_listen_uri = "http://#{node[:ipaddress]}:12950/"

template '/etc/graylog/radio/radio.conf' do
  source 'graylog.radio.conf.erb'
  owner 'root'
  group node.graylog2[:radio][:group]
  mode 0640
  variables(
    :radio_server_uri => node.graylog2[:radio][:server_uri] || default_server_uri,
    :radio_rest_listen_uri => node.graylog2[:radio][:rest][:listen_uri] || default_rest_listen_uri
  )

  notifies :restart, 'service[graylog-radio]', node.graylog2[:restart].to_sym
end

if platform_family?('debian')
  args_file = '/etc/default/graylog-radio'
elsif platform_family?('rhel')
  args_file = '/etc/sysconfig/graylog-radio'
else
  Chef::Log.error 'Platform not supported.'
end

template args_file do
  source 'graylog.radio.default.erb'
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog-radio]', node.graylog2[:restart].to_sym
end

template '/etc/graylog/radio/log4j.xml' do
  source 'graylog.radio.log4j.xml.erb'
  owner 'root'
  group node.graylog2[:radio][:group]
  mode 0640
  notifies :restart, 'service[graylog-radio]', node.graylog2[:restart].to_sym
end
