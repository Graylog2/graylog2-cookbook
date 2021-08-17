package_name = ''

case node['platform']
when 'ubuntu', 'debian'
  repository_package_name = "graylog-sidecar-repository_#{node['graylog2']['sidecar']['repository']['version']}-#{node['graylog2']['sidecar']['repository']['release']}_all.deb"

when 'redhat', 'centos', 'oracle'
  repository_package_name = "graylog-sidecar-repository-#{node['graylog2']['sidecar']['repository']['version']}-#{node['graylog2']['sidecar']['repository']['release']}.noarch.rpm"
end

repository_package_url = "https://packages.graylog2.org/repo/packages/#{repository_package_name}"
repository_path = "#{Chef::Config['file_cache_path'] || '/tmp'}/#{repository_package_name}"

remote_file "#{repository_path}" do
  source "#{repository_package_url}"
  action :create_if_missing
end

case node['platform']
when 'ubuntu', 'debian'
  dpkg_package 'Install Sidecar Repository' do
    package_name "#{repository_package_name}"
    source "#{repository_path}"
  end

  apt_update 'Run apt-get update' do
    action 'update'
  end

  apt_package 'graylog-sidecar' do
    package_name 'graylog-sidecar'
    version "#{node['graylog2']['sidecar']['version']}-#{node['graylog2']['sidecar']['release']}"
    options '--assume-yes'
    action :install
    notifies :restart, 'service[graylog-sidecar]'
  end

when 'redhat', 'centos', 'oracle'
  dnf_package 'Install Sidecar Repository' do
    package_name "#{repository_package_name}"
    source "#{repository_path}"
    flush_cache after: true
  end

  dnf_package 'Install Graylog Sidecar' do
    package_name 'graylog-sidecar'
    version "#{node['graylog2']['sidecar']['version']}-#{node['graylog2']['sidecar']['release']}"
    action :install
    notifies :restart, 'service[graylog-sidecar]'
  end
end


template '/etc/graylog/sidecar/sidecar.yml' do
  action :create
  source 'graylog.collector-sidecar.yml.erb'
  notifies :restart, 'service[graylog-sidecar]'
end

execute 'install service graylog-collector-sidecar' do
  command '/usr/bin/graylog-sidecar -service install'
  notifies :restart, 'service[graylog-sidecar]'
  case node['platform']
  when 'ubuntu'
    not_if { File.exist?('/etc/systemd/system/graylog-sidecar.service') }
  when 'debian', 'redhat', 'centos', 'oracle'
    not_if { File.exist?('/etc/systemd/system/graylog-sidecar.service') }
  end
end

service 'graylog-sidecar' do
  action [:enable, :start]
end
