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

  if new_resource.dashboard
    dashboards = [new_resource.dashboard]
  else
    dashboards = node[:graylog2][:dashboards]
  end

  unless dashboards.nil?
    dashboards.each do |dashboard|
      parsed_dashboard = JSON.parse(dashboard)
      response = connection.get('/dashboards')

      if parsed_dashboard['title'] != new_resource.name && new_resource.dashboard
        Chef::Log.warn('Make sure that dashboard title and resource name are identical to prevent problems with duplicate dashboards.')
      end

      if response.success?
        parsed_response = JSON.parse(response.body)
        saved_dashboards = parsed_response.fetch('dashboards')
        break if existent_dashboard?(saved_dashboards, parsed_dashboard)
      end

      if new_resource.widgets
        widgets = JSON.parse(new_resource.widgets)
      else
        widgets = parsed_dashboard['widgets']
        parsed_dashboard.delete('widgets')
      end
      Chef::Application.fatal!('You need to set dashboard widgets in order to create a dashboard') if widgets.nil?

      dashboard_id = create_dashboard(connection, parsed_dashboard)

      positions = []

      widgets.each do |widget|
        position = widget.delete('position')
        widget_id = create_dashboard_widget(connection, dashboard_id, widget)
        positions << position.merge(id: widget_id) if position
      end

      create_dashboard_widget_positions(connection, dashboard_id, positions) unless positions.empty?
      new_resource.updated_by_last_action(true)
    end
  end
end

def create_dashboard(connection, data)
  begin
    response = connection.post('/dashboards', data.to_json, :'Content-Type' => 'application/json')
    dashboard_id = JSON.parse(response.body).fetch('dashboard_id')
    Chef::Log.debug("Graylog2 API response: #{response.status}")
  rescue StandardError => e
    Chef::Application.fatal!("Failed to create dashboard #{data.fetch('title')}.\n#{e.message}")
  end

  dashboard_id
end

def create_dashboard_widget(connection, dashboard_id, data)
  begin
    response = connection.post("/dashboards/#{dashboard_id}/widgets", data.to_json, :'Content-Type' => 'application/json')
    widget_id = JSON.parse(response.body).fetch('widget_id')
    Chef::Log.info("Graylog2 API response: #{response.status}")
  rescue StandardError => e
    Chef::Application.fatal!("Failed to create dashboard widget #{data.fetch('title')}.\n#{e.message}")
  end

  widget_id
end

def create_dashboard_widget_positions(connection, dashboard_id, positions)
  data = { positions: positions }
  response = connection.put("/dashboards/#{dashboard_id}/positions", data.to_json, :'Content-Type' => 'application/json')
  Chef::Log.info("Graylog2 API response: #{response.status}")

  response
end

def existent_dashboard?(saved_dashboards, dashboard)
  saved_dashboards.each do |saved_dashboard|
    return true if saved_dashboard.fetch('title') == dashboard.fetch('title')
  end

  false
end
