require 'spec_helper'

describe service('graylog-server') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/graylog/server/server.conf') do
  it { should be_file }
  its(:content) { should match(/# Cluster settings/) }
end

describe file('/etc/sysconfig/graylog-server'), :if => os[:family] == 'redhat' do
  it { should be_file }
  its(:content) { should match(/GRAYLOG_SERVER_ARGS/) }
end

describe file('/etc/default/graylog-server'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(/GRAYLOG_SERVER_ARGS/) }
end

describe file('/etc/graylog/server/log4j2.xml') do
  it { should be_file }
  its(:content) { should match(/server.log/) }
end

describe file('/etc/graylog/server/graylog-elasticsearch.yml') do
  it { should be_file }
  its(:content) { should match(/cluster.name: graylog/) }
end
