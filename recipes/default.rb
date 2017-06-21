version = node['graylog2']['major_version']
raise('Java version needs to be >= 8') if node['java']['jdk_version'].to_i < 8

if platform_family?('rhel', 'amazon')
  repository_file = "graylog-#{version}-repository_latest.rpm"
  repository_url = "https://packages.graylog2.org/repo/packages/#{repository_file}"
elsif platform_family?('debian')
  repository_file = "graylog-#{version}-repository_latest.deb"
  repository_url = "https://packages.graylog2.org/repo/packages/#{repository_file}"
  package 'apt-transport-https'
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

if node['graylog2']['server']['repos'].empty?
  remote_file "#{Chef::Config[:file_cache_path]}/#{repository_file}" do
    action :create_if_missing
    source repository_url
  end

  package repository_file do
    action :install
    source "#{Chef::Config[:file_cache_path]}/#{repository_file}"
    if platform_family?('rhel', 'amazon')
      provider Chef::Provider::Package::Rpm
      options '--force'
      notifies :run, 'execute[yum-clean]', :immediately
    elsif platform?('ubuntu', 'debian')
      provider Chef::Provider::Package::Dpkg
      options '--force-confold --force-overwrite'
      notifies :run, 'execute[apt-update]', :immediately
    end
  end
elsif platform_family?('rhel', 'amazon')
  yum_repository 'graylog' do
    description 'Graylog repository'
    baseurl     node['graylog2']['server']['repos']['rhel']['url']
    gpgkey      node['graylog2']['server']['repos']['rhel']['key']
  end
elsif platform?('ubuntu', 'debian')
  apt_repository 'graylog' do
    uri          node['graylog2']['server']['repos']['debian']['url']
    distribution node['graylog2']['server']['repos']['debian']['distribution']
    components   node['graylog2']['server']['repos']['debian']['components']
    key          node['graylog2']['server']['repos']['debian']['key']
  end
end
