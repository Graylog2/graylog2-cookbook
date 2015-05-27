require 'spec_helper'

describe service('graylog-collector') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/graylog/collector/collector.conf') do
  it { should be_file }
  its(:content) { should match(/local-syslog/) }
end
