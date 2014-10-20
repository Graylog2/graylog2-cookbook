require 'spec_helper'

describe service('graylog2-server') do
  it { should be_enabled }
  it { should be_running}
end

describe file('/etc/graylog2.conf') do
  it { should be_file }
  its(:content) { should match /# Cluster settings/ }
end

describe file('/etc/sysconfig/graylog2-server'), :if => os[:family] == 'redhat' do
  it { should be_file }
  its(:content) { should match /GRAYLOG2_SERVER_ARGS/ }
end

describe file('/etc/default/graylog2-server'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  it { should be_file }
  its(:content) { should match /GRAYLOG2_SERVER_ARGS/ }
end

describe file('/etc/graylog2/server/log4j.xml') do
  it { should be_file }
  its(:content) { should match /server.log/ }
end

describe file('/etc/graylog2-elasticsearch.yml') do
  it { should be_file }
  its(:content) { should match /cluster.name: graylog2/ }
end

# REST API
describe port(12900) do
  it { should be_listening }
end

# Transport
describe port(9350) do
  it { should be_listening }
end
