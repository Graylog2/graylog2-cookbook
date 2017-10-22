module Extensions
  module ApiHelper
    def auth_params(new_resource)
      {
        base_url: new_resource.api_uri || node['graylog2']['rest']['listen_uri'],
        token: new_resource.api_token || node['graylog2']['rest']['admin_access_token']
      }
    end

    def keys_to_symbols(hash)
      hash.each_with_object({}) do |(k, v), new_hash|
        new_hash[k.to_sym] = v
        new_hash
      end
    end
  end
end
