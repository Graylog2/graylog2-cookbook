if platform?('ubuntu', 'debian')
  include_recipe 'authbind::default'

  node.default['graylog2']['server']['wrapper'] = 'authbind'
  node.default['graylog2']['radio']['wrapper']  = 'authbind'
  if node['graylog2']['authorized_ports'].is_a?(Array)
    node['graylog2']['authorized_ports'].each do |authorized_port|
      authbind_port "AuthBind graylog-server port #{authorized_port}" do
        port authorized_port
        user node['graylog2']['server']['user']
        only_if "getent passwd #{node['graylog2']['server']['user']}"
      end
    end
  elsif !node['graylog2']['authorized_ports'].nil?
    authbind_port "AuthBind graylog-server port #{node['graylog2']['authorized_ports']}" do
      port node['graylog2']['authorized_ports']
      user node['graylog2']['server']['user']
      only_if "getent passwd #{node['graylog2']['server']['user']}"
    end
  end
else
  Chef::Log.error 'Authbind is only available on Ubuntu/Debian systems.'
end
