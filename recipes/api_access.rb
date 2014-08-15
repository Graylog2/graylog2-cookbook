chef_gem "mongo"
chef_gem "faraday"
chef_gem "faraday-conductivity"

Chef::Log.info "Wait until the Graylog2 API is ready"
torch_graylog2_api_check "api_check"
Chef::Log.info "Graylog2 API available, resume provision"

torch_graylog2_token "admin"
torch_graylog2_inputs "inputs_from_attributes"
