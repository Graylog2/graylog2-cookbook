graylog2_input 'global beats input' do
  type 'Beats'
  settings(configuration: { bind_address: '0.0.0.0', port: 5044 })
end

graylog2_input 'local syslog tcp input' do
  hostname 'graylog.local'
  type 'Syslog TCP'
  settings(configuration: { bind_address: '0.0.0.0', port: 5015 })
end
