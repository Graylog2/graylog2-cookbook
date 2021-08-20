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
  jvm_options %w(
                -XX:+AlwaysPreTouch
                -server
                -Xss1m
                -Djava.awt.headless=true
                -Dfile.encoding=UTF-8
                -Djna.nosys=true
                -XX:-OmitStackTraceInFastThrow
                -Dio.netty.noUnsafe=true
                -Dio.netty.noKeySetOptimization=true
                -Dio.netty.recycler.maxCapacityPerThread=0
                -Dlog4j.shutdownHookEnabled=false
                -Dlog4j2.disable.jmx=true
                -XX:+HeapDumpOnOutOfMemoryError
              )
  configuration ({
    'cluster.name' => node['elasticsearch']['cluster']['name']
  })
end
elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end
