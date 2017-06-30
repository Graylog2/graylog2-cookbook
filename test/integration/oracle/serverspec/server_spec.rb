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

# REST API
describe command('timeout 60 bash -c "until curl -s -H \'Accept: application/json\' http://127.0.0.1:9000/api/; do sleep 1; done"') do
  its(:stdout) { should match 'node_id' }
end

# Web UI
describe command('timeout 60 bash -c "until curl -s http://127.0.0.1:9000; do sleep 1; done"') do
  its(:stdout) { should match 'html' }
end
