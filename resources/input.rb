property :title, String, name_property: true, required: true
property :hostname, [String, nil], default: nil
property :type, String, required: true
property :settings, Hash, required: true

# api auth settings
property :api_uri, [String, nil], default: nil
property :api_token, [String, nil], default: nil

default_action :create

action :create do
  require 'graylogapi'
  extend Extensions::ApiHelper

  graylogapi = GraylogAPI.new(auth_params(new_resource))

  options = {
    title: new_resource.title,
    global: new_resource.hostname.nil?,
    node: hostname_to_node_id(graylogapi, new_resource.hostname),
    type: type_to_type_id(graylogapi, new_resource.type),
  }.merge(new_resource.settings)

  response = graylogapi.system.inputs.create(options)

  log 'Can`t create input' do
    message response.body.to_s
    level :fatal
    only_if { response.fail? }
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

def type_to_type_id(graylogapi, type)
  graylogapi.system.inputs.types.name_to_type(type)
end
