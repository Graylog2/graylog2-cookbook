require 'spec_helper'

describe service('graylog-sidecar') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/graylog/sidecar/sidecar.yml') do
  it { should be_file }
  its(:content) { should match(%r{server_url: http:\/\/localhost:9000\/api}) }
end
