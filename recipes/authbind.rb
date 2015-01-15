include_recipe "authbind::default"

if platform?("ubuntu", "debian")
  node.default.graylog2[:server][:wrapper] = 'authbind'
  node.default.graylog2[:radio][:wrapper]  = 'authbind'
  if node.graylog2[:authorized_ports].kind_of?(Array)
    node.graylog2[:authorized_ports].each do |authorized_port|
      authbind_port "AuthBind Graylog2 port #{authorized_port}" do
          port authorized_port
          user node.graylog2[:user]
      end
    end
  elsif not node.graylog2[:authorized_ports].nil?
    authbind_port "AuthBind Graylog2 port #{node.graylog2[:authorized_ports]}" do
        port node.graylog2[:authorized_ports]
        user node.graylog2[:user]
    end
  end
else
  Chef::Log.error "Authbind is only available on Ubuntu/Debian systems."
end
