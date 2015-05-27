action :create do
  require 'json'
  require 'faraday'
  require 'faraday/conductivity'

  Chef::Application.fatal!('You need to set an access token in order to use the API.') if node[:graylog2][:rest][:admin_access_token].nil?

  rest_uri = node[:graylog2][:rest][:listen_uri] || "http://#{node[:ipaddress]}:12900/"
  connection = Faraday.new(url: rest_uri) do |faraday|
    faraday.basic_auth(node[:graylog2][:rest][:admin_access_token], 'token')
    faraday.adapter(Faraday.default_adapter)
    faraday.use :repeater, retries: 5, mode: :one
  end

  if new_resource.stream
    streams = [new_resource.stream]
  else
    streams = node[:graylog2][:streams]
  end

  unless streams.nil?
    streams.each do |stream|
      parsed_stream = JSON.parse(stream)
      response = connection.get('/streams')

      if parsed_stream['title'] != new_resource.name && new_resource.stream
        Chef::Log.warn('Make sure that stream title and resource name are identical to prevent problems with duplicate streams.')
      end

      if response.success?
        parsed_response = JSON.parse(response.body)
        saved_streams = parsed_response.fetch('streams')
        break if existent_stream?(saved_streams, parsed_stream)
      end

      if new_resource.rules
        rules = JSON.parse(new_resource.rules)
      else
        rules = parsed_stream['rules']
        parsed_stream.delete('rules')
      end
      Chef::Application.fatal!('You need to set stream rules in order to create a stream') if rules.nil?

      if new_resource.alert_conditions
        alert_conditions = JSON.parse(new_resource.alert_conditions)
      else
        alert_conditions = parsed_stream['alert_conditions']
        parsed_stream.delete('alert_conditions')
      end

      if new_resource.alarm_callbacks
        alarm_callbacks = JSON.parse(new_resource.alarm_callbacks)
      else
        alarm_callbacks = parsed_stream['alarm_callbacks']
        parsed_stream.delete('alarm_callbacks')
      end

      stream_id = create_stream(connection, parsed_stream)

      rules.each do |rule|
        create_stream_rule(connection, stream_id, rule)
      end

      if alert_conditions
        alarm_callbacks.each do |alarm_callback|
          create_stream_alarm_callback(connection, stream_id, alarm_callback)
        end

        alert_conditions.each do |alert_condition|
          create_stream_alert_condition(connection, stream_id, alert_condition)
        end
      end

      resume_stream(connection, stream_id)
      new_resource.updated_by_last_action(true)
    end
  end
end

def create_stream(connection, data)
  begin
    response = connection.post('/streams', data.to_json, :'Content-Type' => 'application/json')
    Chef::Log.debug("Graylog2 API response: #{response.status}")
    stream_id = JSON.parse(response.body).fetch('stream_id')
  rescue StandardError => e
    Chef::Application.fatal!("Failed to create stream #{data.fetch('title')}.\n#{e.message}")
  end

  stream_id
end

def create_stream_rule(connection, stream_id, data)
  response = connection.post("/streams/#{stream_id}/rules", data.to_json, :'Content-Type' => 'application/json')
  Chef::Log.debug("Graylog2 API response: #{response.status}")

  response
end

def create_stream_alarm_callback(connection, stream_id, data)
  response = connection.post("/streams/#{stream_id}/alarmcallbacks", data.to_json, :'Content-Type' => 'application/json')
  Chef::Log.debug("Graylog2 API response: #{response.status}")
end

def create_stream_alert_condition(connection, stream_id, data)
  response = connection.post("/streams/#{stream_id}/alerts/conditions", data.to_json, :'Content-Type' => 'application/json')
  Chef::Log.debug("Graylog2 API response: #{response.status}")
end

def resume_stream(connection, stream_id)
  response = connection.post("/streams/#{stream_id}/resume", nil, :'Content-Type' => 'application/json')
  Chef::Log.debug("Graylog2 API response: #{response.status}")

  response
end

def existent_stream?(saved_streams, stream)
  saved_streams.each do |saved_stream|
    return true if saved_stream.fetch('title') == stream.fetch('title')
  end

  false
end
