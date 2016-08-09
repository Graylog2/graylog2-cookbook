apt_repository 'backports' do
  uri 'http://http.debian.net/debian'
  components ['jessie-backports', 'main']
end if node['platform_family'] == 'debian' && node['platform_version'].start_with?("8")
