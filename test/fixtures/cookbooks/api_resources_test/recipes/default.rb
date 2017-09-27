graylog2_input 'global beats input' do
  type 'Beats'
  address '0.0.0.0'
  port 5014
end

graylog2_input 'local syslog tcp input' do
  hostname 'f594fbd6-9277-4e8f-9eba-e8d318f41872'
  type 'Syslog TCP'
  address '0.0.0.0'
  port 5015
end
