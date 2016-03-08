elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type node['elasticsearch']['install_type'].to_sym
end
elasticsearch_configure 'elasticsearch'
elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end
