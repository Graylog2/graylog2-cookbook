module Extensions
  module ApiHelper
    def auth_params(new_resource)
      {
        base_url: new_resource.api_uri || node['graylog2']['rest']['listen_uri'],
        token: new_resource.api_token || node['graylog2']['rest']['admin_access_token']
      }
    end
  end
end
