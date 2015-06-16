# Override attributes from data bag's "collector" section
begin
  secrets = Chef::EncryptedDataBagItem.load(node.graylog2[:secrets_data_bag], 'graylog')['collector']
rescue
  Chef::Log.debug 'Can not merge collector secrets from databag'
end
Chef::Mixin::DeepMerge.deep_merge!(secrets, node.override[:graylog2]) unless secrets.nil?

group node.graylog2[:collector][:group]

user node.graylog2[:collector][:user] do
  home '/usr/share/graylog-collector'
  shell '/bin/false'
  gid node.graylog2[:collector][:group]
  system true
end

group 'adm' do
  action :modify
  members node.graylog2[:collector][:user]
  append true
end

ark 'graylog-collector' do
  action :put
  url node.graylog2[:collector][:package_url]
  version node.graylog2[:collector][:version]
  path '/usr/share'
  owner node.graylog2[:collector][:user]
end

directory '/etc/graylog/collector' do
  action :create
  owner node.graylog2[:collector][:user]
  group node.graylog2[:collector][:group]
end

template '/etc/graylog/collector/collector.conf' do
  action :create
  source 'graylog.collector.conf.erb'
  owner node.graylog2[:collector][:user]
  group node.graylog2[:collector][:group]
end

case node[:platform]
when 'ubuntu'
  template '/etc/init/graylog-collector.conf' do
    action :create
    source 'graylog.collector.upstart.conf.erb'
    owner 'root'
    group 'root'
  end

  service 'graylog-collector' do
    action [:enable, :start]
    provider Chef::Provider::Service::Upstart if node[:platform_version].to_f >= 9.10
  end

when 'debian'
  directory '/var/log/graylog-collector' do
    action :create
    owner node.graylog2[:collector][:user]
    group node.graylog2[:collector][:group]
  end

  template '/etc/init.d/graylog-collector' do
    action :create
    source 'graylog.collector.debian-init.erb'
    owner 'root'
    group 'root'
    mode 0755
  end

  service 'graylog-collector' do
    action [:enable, :start]
    provider Chef::Provider::Service::Init::Debian
  end

when 'redhat', 'centos'
  directory '/var/log/graylog-collector' do
    action :create
    owner node.graylog2[:collector][:user]
    group node.graylog2[:collector][:group]
  end

  template '/etc/init.d/graylog-collector' do
    action :create
    source 'graylog.collector.redhat-init.erb'
    owner 'root'
    group 'root'
    mode 0755
  end

  service 'graylog-collector' do
    action [:enable, :start]
    provider Chef::Provider::Service::Init::Redhat
  end
end
