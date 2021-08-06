elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type 'package'
  version node['elasticsearch']['version']
  download_url node['elasticsearch']['download_url']
  download_checksum node['elasticsearch']['download_checksum']
  action :install
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
