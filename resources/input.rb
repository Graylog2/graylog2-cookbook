property :title, String, name_property: true, required: true
property :hostname, [String, nil], default: nil
property :type, String, required: true
property :settings, Hash, required: true

# api auth settings
property :api_uri, [String, nil], default: nil
property :api_token, [String, nil], default: nil

default_action :create

# this field use for update request
attr_reader :input_id

load_current_value do
  require 'graylogapi'
  extend Extensions::ApiHelper
  graylogapi = GraylogAPI.new(auth_params(self))

  graylog_inputs = graylogapi.system.inputs
  inputs = graylog_inputs.all['inputs']
  current_input = inputs.find { |i| i['title'] == title }

  current_value_does_not_exist! if current_input.nil?

  node = graylogapi.system.cluster.node_by_id(current_input['node'])

  title current_input['title']
  type graylog_inputs.types.type_to_name(current_input['type'])
  hostname current_input['global'] ? nil : node['hostname']
  settings(configuration: keys_to_symbols(current_input['attributes']))

  # this use for update request
  @input_id = current_input['id']
end

action :create do
  converge_if_changed do
    require 'graylogapi'
    extend Extensions::ApiHelper
    graylogapi = GraylogAPI.new(auth_params(new_resource))
    graylogapi_inputs = graylogapi.system.inputs

    options = {
      title: new_resource.title,
      global: new_resource.hostname.nil?,
      type: graylogapi_inputs.types.name_to_type(new_resource.type),
    }.merge(new_resource.settings)

    unless new_resource.hostname.nil?
      options[:node] = graylogapi.system.cluster.node_by_hostname(new_resource.hostname)['node_id']
    end

    response =
      if current_resource.nil?
        graylogapi_inputs.create(options)
      else
        graylogapi_inputs.update(current_resource.input_id, options)
      end

    log 'Can`t create input' do
      message response.body.to_s
      level :fatal
      only_if { response.fail? }
    end
  end
end

action :delete do
  require 'graylogapi'
  extend Extensions::ApiHelper
  graylogapi = GraylogAPI.new(auth_params(new_resource))

  input = graylogapi.system.inputs.all['inputs'].find { |i| i['title'] == 'global beats input' }

  if input.nil?
    log 'Input already deleted' do
      level :info
    end
  else
    graylogapi.system.inputs.delete(input['id'])
  end
end
