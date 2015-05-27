require 'spec_helper'

describe service('graylog-web') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/graylog/web/web.conf') do
  it { should be_file }
  its(:content) { should match(/graylog2-server.uris/) }
end

describe file('/etc/sysconfig/graylog-web'), :if => os[:family] == 'redhat' do
  it { should be_file }
  its(:content) { should match(/GRAYLOG_WEB_ARGS/) }
end

describe file('/etc/default/graylog-web'), :if => ['debian', 'ubuntu'].include?(os[:family])do
  it { should be_file }
  its(:content) { should match(/GRAYLOG_WEB_ARGS/) }
end

describe file('/etc/graylog/web/logback.xml') do
  it { should be_file }
  its(:content) { should match(/application.log/) }
end

# Web UI
describe port(9_000) do
  it { should be_listening }
end
