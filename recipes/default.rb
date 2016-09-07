version = node.graylog2[:major_version]
repo_version = node.graylog2[:repo_version]
raise('Java version needs to be >= 8') if node[:java][:jdk_version].to_i < 8

if platform_family?('rhel')
  repository_file = "graylog-#{version}-repository-#{repo_version}.noarch.rpm"
  repository_url = "https://packages.graylog2.org/repo/el/stable/#{version}/x86_64/#{repository_file}"
elsif platform_family?('debian')
  repository_file = "graylog-#{version}-repository_#{repo_version}_all.deb"
  repository_url = "https://packages.graylog2.org/repo/debian/pool/stable/#{version}/g/graylog-#{version}-repository/#{repository_file}"
  package 'apt-transport-https'
end

remote_file "#{Chef::Config[:file_cache_path]}/#{repository_file}" do
  action :create_if_missing
  source repository_url
end

execute 'apt-update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
end

execute 'yum-clean' do
  command 'yum clean all'
  ignore_failure true
  action :nothing
end

package repository_file do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{repository_file}"
  if platform_family?('rhel')
    provider Chef::Provider::Package::Rpm
    options '--force'
    notifies :run, 'execute[yum-clean]', :immediately
  elsif platform?('ubuntu', 'debian')
    provider Chef::Provider::Package::Dpkg
    options '--force-confold --force-overwrite'
    notifies :run, 'execute[apt-update]', :immediately
  end
end
