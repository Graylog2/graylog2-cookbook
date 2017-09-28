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
  }.merge(new_resource.settings)

  options[:type] =
    begin
      graylogapi.system.inputs.types.name_to_type(new_resource.type)
    rescue
      raise "Can't find inpyt type: #{new_resource.type}"
    end

  options[:node] =
    if new_resource.hostname.nil?
      nil
    else
      begin
        graylogapi.system.cluster.nodes['nodes'].find do |i|
          i['hostname'] == 'graylog.local'
        end['node_id']
      rescue
        raise "Can't find node with hostname: #{new_resource.hostname}"
      end
    end

  response = graylogapi.system.inputs.create(options)

  log 'Can`t create input' do
    message response.body.to_s
    level :fatal
    only_if { response.fail? }
  end
end
