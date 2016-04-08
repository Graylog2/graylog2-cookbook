# Override attributes from data bag's "collector" section
begin
  secrets = Chef::EncryptedDataBagItem.load(node.graylog2[:secrets_data_bag], 'graylog')['collector']
rescue
  Chef::Log.debug 'Can not load collector secrets from databag'
end

if (node['platform'] == 'debian' && node['platform_version'] == '8') || (node['platform'] == 'ubuntu' && (node['platform_version'] == '14.04' || node['platform_version'] == '12.04'))
  apt_repository 'graylog-collector' do
    uri 'https://packages.graylog2.org/repo/debian/'
    distribution node['lsb']['codename']
    components ['collector-latest']
    key 'https://packages.graylog2.org/repo/debian/keyring.gpg'
  end

  execute 'graylogcollector-apt-get-update' do
    command 'apt-get update'
    action :nothing
  end
  package 'graylog-collector' do
    action :install
    options '--no-install-recommends --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"' if platform_family?('debian')
    notifies :restart, 'service[graylog-collector]', node.graylog2[:restart].to_sym
  end

  service 'graylog-collector' do
    action :nothing
    supports :status => true, :restart => true
    restart_command node.graylog2[:collector][:override_restart_command] if node.graylog2[:collector][:override_restart_command]
    provider Chef::Provider::Service::Upstart if platform?('ubuntu')
  end

elsif node['platform'] == 'centos' && node['platform_version'] == '7'
  remote_file "#{Chef::Config['file_cache_path'] || '/tmp'}/graylog-collector-latest-repository-el7_latest.rpm" do
    source 'https://packages.graylog2.org/repo/packages/graylog-collector-latest-repository-el7_latest.rpm'
    action :create_if_missing
  end

  package 'graylog-collector-repo' do
    source "#{Chef::Config['file_cache_path'] || '/tmp'}/graylog-collector-latest-repository-el7_latest.rpm"
    provider Chef::Provider::Package::Rpm
    action :install
    notifies :restart, 'service[graylog-collector]', node.graylog2[:restart].to_sym
  end
  service 'graylog-collector' do
    action :nothing
    supports :status => true, :restart => true
    restart_command node.graylog2[:collector][:override_restart_command] if node.graylog2[:collector][:override_restart_command]
    provider Chef::Provider::Service::Init::Redhat
  end
else
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
    recursive true
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

    directory '/var/log/graylog-collector' do
      action :create
      owner node.graylog2[:collector][:user]
      group node.graylog2[:collector][:group]
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
end

template '/etc/graylog/collector/collector.conf' do
  action :create
  source 'graylog.collector.conf.erb'
  owner node.graylog2[:collector][:user]
  group node.graylog2[:collector][:group]
end
