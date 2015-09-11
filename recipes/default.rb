version = node.graylog2[:major_version]
Chef::Application.fatal!('Java version needs to be >= 7') if node[:java][:jdk_version].to_i < 7

if platform_family?('rhel')
  repository_file = "graylog-#{version}-repository-el6_latest.rpm"
elsif platform?('ubuntu')
  repository_file = "graylog-#{version}-repository-ubuntu14.04_latest.deb"
elsif platform?('debian')
  repository_file = "graylog-#{version}-repository-debian7_latest.deb"
  package 'apt-transport-https'
end

remote_file "#{Chef::Config[:file_cache_path]}/#{repository_file}" do
  action :create_if_missing
  source "https://packages.graylog2.org/repo/packages/#{repository_file}"
end

execute 'apt-update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
end

package repository_file do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{repository_file}"
  if platform_family?('rhel')
    provider Chef::Provider::Package::Rpm
  elsif platform?('ubuntu', 'debian')
    provider Chef::Provider::Package::Dpkg
    notifies :run, 'execute[apt-update]', :immediately
  end
end
