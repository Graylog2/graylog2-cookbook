package 'gcc' if platform_family?('rhel', 'amazon')

chef_gem 'mongo' do
  compile_time false
  version '~> 2'
end

chef_gem 'graylogapi' do
  compile_time false
  version '~> 1'
end
