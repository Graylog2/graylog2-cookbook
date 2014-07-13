require 'spec_helper'

describe service('graylog2-radio') do
  it { should be_enabled }
  it { should be_running}
end

describe file('/etc/graylog2-radio.conf') do
  it { should be_file }
  its(:content) { should match /transport_type/ }
end

describe file('/etc/graylog2/radio/log4j.xml') do
  it { should be_file }
  its(:content) { should match /radio.log/ }
end

# REST
describe port(12950) do
  it { should be_listening }
end
