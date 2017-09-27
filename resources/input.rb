property :title, String, name_property: true, required: true
property :hostname, [String, nil], default: nil
property :type, String, required: true
property :address, String, required: true
property :port, Integer, required: true

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
    node: new_resource.hostname.nil? ? nil : new_resource.hostname,
    configuration: {
      bind_address: new_resource.address,
      port: new_resource.port
    }
  }

  options[:type] =
    begin
      graylogapi.system.inputs.types.name_to_type(new_resource.type)
    rescue
      raise "Can't find inpyt type: #{new_resource.type}"
    end

  response = graylogapi.system.inputs.create(options)

  log 'Can`t create input' do
    message response.body.to_s
    level :fatal
    only_if { response.fail? }
  end
end
