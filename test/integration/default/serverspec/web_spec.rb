require 'spec_helper'

describe service('graylog2-web') do
  it { should be_enabled }
  it { should be_running}
end

describe file('/etc/graylog2/web/graylog2-web-interface.conf') do
  it { should be_file }
  its(:content) { should match /graylog2-server.uris/ }
end

describe file('/etc/sysconfig/graylog2-web'), :if => os[:family] == 'redhat' do
  it { should be_file }
  its(:content) { should match /GRAYLOG2_WEB_ARGS/ }
end

describe file('/etc/default/graylog2-web'), :if => ['debian', 'ubuntu'].include?(os[:family])do
  it { should be_file }
  its(:content) { should match /GRAYLOG2_WEB_ARGS/ }
end

describe file('/etc/graylog2/web/logback.xml') do
  it { should be_file }
  its(:content) { should match /application.log/ }
end

# Web UI
describe port(9000) do
  it { should be_listening }
end
