require 'spec_helper'

describe service('collector-sidecar') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
  it { should be_file }
  its(:content) { should match(/server_url: http:\/\/localhost:12900/) }
end
