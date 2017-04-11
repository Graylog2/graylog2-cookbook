package_name = ''

case node['platform']
when 'ubuntu', 'debian'
  arch = if ['amd64', 'x64', 'x86_64'].include? node['graylog2']['sidecar']['arch']
           'amd64'
         else
           'i386'
         end
  package_name = "collector-sidecar_#{node['graylog2']['sidecar']['version']}-#{node['graylog2']['sidecar']['build']}_#{arch}.deb"
when 'redhat', 'centos', 'oracle'
  arch = if ['amd64', 'x64', 'x86_64'].include? node['graylog2']['sidecar']['arch']
           'x86_64'
         else
           'i386'
         end
  package_name = "collector-sidecar-#{node['graylog2']['sidecar']['version']}-#{node['graylog2']['sidecar']['build']}.#{arch}.rpm"
end

remote_file "#{Chef::Config['file_cache_path'] || '/tmp'}/#{package_name}" do
  source "#{node['graylog2']['sidecar']['package_base_url']}/#{package_name}"
  action :create_if_missing
end

package 'graylog-collector-sidecar' do
  action :install
  source "#{Chef::Config['file_cache_path'] || '/tmp'}/#{package_name}"
  version "#{node['graylog2']['sidecar']['version']}-#{node['graylog2']['sidecar']['build']}"
  case node['platform']
  when 'ubuntu', 'debian'
    provider Chef::Provider::Package::Dpkg
    options '--force-confold'
  when 'redhat', 'centos', 'oracle'
    provider Chef::Provider::Package::Rpm
  end
  notifies :restart, 'service[collector-sidecar]'
end

template '/etc/graylog/collector-sidecar/collector_sidecar.yml' do
  action :create
  source 'graylog.collector-sidecar.yml.erb'
  notifies :restart, 'service[collector-sidecar]'
end

execute 'install service graylog-collector-sidecar' do
  command '/usr/bin/graylog-collector-sidecar -service install'
  notifies :restart, 'service[collector-sidecar]'
  case node['platform']
  when 'ubuntu'
    not_if { File.exist?('/etc/systemd/system/collector-sidecar.service') || File.exist?('/etc/init/collector-sidecar.conf') }
  when 'debian', 'redhat', 'centos', 'oracle'
    not_if { File.exist?('/etc/systemd/system/collector-sidecar.service') || File.exist?('/etc/init.d/collector-sidecar') }
  end
end

service 'collector-sidecar' do
  action [:enable, :start]
end
