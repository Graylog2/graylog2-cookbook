# load template extensions, look under libraries/ for more informations
Erubis::Context.send(:include, Extensions::Templates)

remote_file "#{Chef::Config[:file_cache_path]}/graylog2-repository-ubuntu14.04_latest.deb" do
  action :create_if_missing
  source "http://packages.graylog2.org/repo/packages/graylog2-repository-ubuntu14.04_latest.deb"
end

dpkg_package "graylog2-repository-ubuntu14.04_latest" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/graylog2-repository-ubuntu14.04_latest.deb"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end
