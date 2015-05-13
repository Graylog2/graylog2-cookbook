# Override attributes from data bag's "collector" section
secrets = Chef::EncryptedDataBagItem.load("secrets", "graylog")["collector"] rescue {}
Chef::Mixin::DeepMerge.deep_merge!(secrets, node.override[:graylog2]) if not secrets.nil?

group node.graylog2[:collector][:group]

user node.graylog2[:collector][:user] do
	home "/usr/share/graylog-collector"
	shell "/bin/false"
	gid node.graylog2[:collector][:group]
	system true
end

group "adm" do
  action :modify
  members node.graylog2[:collector][:user]
  append true
end

ark "graylog-collector" do
	action :put
	url node.graylog2[:collector][:package_url]
	version node.graylog2[:collector][:version]
	path "/usr/share"
	owner node.graylog2[:collector][:user]
end

directory "/etc/graylog/collector" do
	action :create
	owner node.graylog2[:collector][:user]
	group node.graylog2[:collector][:group]
end

template "/etc/graylog/collector/collector.conf" do
	action :create
  source "graylog.collector.conf.erb"
  owner node.graylog2[:collector][:user]
  group node.graylog2[:collector][:group]
end

case node["platform"]
  when "ubuntu"
    template "/etc/init/graylog-collector.conf" do
      action :create
      source "graylog.collector.upstart.conf.erb"
      owner "root"
      group "root"
    end

    service "graylog-collector" do
      if node["platform_version"].to_f >= 9.10
        provider Chef::Provider::Service::Upstart
      end
      action [:enable, :start]
    end

  when "debian"
    directory "/var/log/graylog-collector" do
      action :create
      owner node.graylog2[:collector][:user]
      group node.graylog2[:collector][:group]
    end

    template "/etc/init.d/graylog-collector" do
      action :create
      source "graylog.collector.debian-init.erb"
      owner "root"
      group "root"
      mode 0755
    end

    service "graylog-collector" do
      provider Chef::Provider::Service::Init::Debian
      action [:enable, :start]
    end
  
  when "redhat", "centos"
    directory "/var/log/graylog-collector" do
      action :create
      owner node.graylog2[:collector][:user]
      group node.graylog2[:collector][:group]
    end

    template "/etc/init.d/graylog-collector" do
      action :create
      source "graylog.collector.redhat-init.erb"
      owner "root"
      group "root"
      mode 0755
    end

    service "graylog-collector" do
      provider Chef::Provider::Service::Init::Redhat
      action [:enable, :start]
    end
end
