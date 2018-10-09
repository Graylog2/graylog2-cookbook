elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type 'package'
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
