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

  inputs = graylogapi.system.inputs.all['inputs']
  current_input = inputs.find { |i| i['title'] == title }

  current_value_does_not_exist! if current_input.nil?

  title current_input['title']
  type type_id_to_type(graylogapi, current_input['type'])
  hostname current_input['global'] ? nil : node_id_to_hostname(graylogapi, current_input['node'])
  settings(configuration: keys_to_symbols(current_input['attributes']))

  # this use for update request
  @input_id = current_input['id']
end

action :create do
  converge_if_changed do
    require 'graylogapi'
    extend Extensions::ApiHelper
    graylogapi = GraylogAPI.new(auth_params(new_resource))

    options = {
      title: new_resource.title,
      global: new_resource.hostname.nil?,
      node: hostname_to_node_id(graylogapi, new_resource.hostname),
      type: type_to_type_id(graylogapi, new_resource.type),
    }.merge(new_resource.settings)

    response =
      if current_resource.nil?
        graylogapi.system.inputs.create(options)
      else
        graylogapi.system.inputs.update(current_resource.input_id, options)
      end

    log 'Can`t create input' do
      message response.body.to_s
      level :fatal
      only_if { response.fail? }
    end
  end
end

def hostname_to_node_id(graylogapi, hostname)
  return nil if hostname.nil?

  node_id = graylogapi.system.cluster.nodes['nodes'].find do |i|
    i['hostname'] == hostname
  end

  raise "Can't find node with hostname '#{hostname}'" if node_id.nil?

  node_id['node_id']
end

def node_id_to_hostname(graylogapi, node_id)
  graylogapi.system.cluster.nodes['nodes'].find do |node|
    node['node_id'] == node_id
  end['hostname']
end

def type_to_type_id(graylogapi, type)
  graylogapi.system.inputs.types.name_to_type(type)
end

def type_id_to_type(graylogapi, type_id)
  graylogapi.system.inputs.types.all.body.find do |_, type|
    type['type'].casecmp(type_id).zero?
  end.last['name']
end

def keys_to_symbols(hash)
  hash.each_with_object({}) do |(k, v), new_hash|
    new_hash[k.to_sym] = v
    new_hash
  end
end
