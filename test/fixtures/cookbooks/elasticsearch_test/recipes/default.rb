elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type node['elasticsearch']['install_type'].to_sym
end
elasticsearch_configure 'elasticsearch' do
  allocated_memory '512m'
  configuration ({
    'cluster.name' => node['elasticsearch']['cluster']['name']
  })
end
elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end
