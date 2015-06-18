action :create do
  require 'mongo'

  Chef::Application.fatal!('You need to set an access token in order to use the API.') if node[:graylog2][:rest][:admin_access_token].nil?
  if node[:graylog2][:major_version].to_f <= 1.0
    client = Mongo::MongoClient.new(node[:graylog2][:mongodb][:host], node[:graylog2][:mongodb][:port])
    db     = client[node[:graylog2][:mongodb][:database]]
    if node[:graylog2][:mongodb][:useauth]
      db.authenticate(node[:graylog2][:mongodb][:user], node[:graylog2][:mongodb][:password])
    end
  else
    client = Mongo::MongoClient.from_uri(node[:graylog2][:mongodb][:uri])
    db     = client[Mongo::URIParser.new(node[:graylog2][:mongodb][:uri]).db_name]
  end

  coll = db['access_tokens']
  if coll.find('NAME' => 'chef').to_a.empty?
    coll.insert(
      'username' => 'admin',
      'NAME'     => 'chef',
      'token'    => node[:graylog2][:rest][:admin_access_token]
    )
  else
    Chef::Log.debug("Graylog2 access_token for #{new_resource} is already set - nothing to do")
  end

  client.close
  new_resource.updated_by_last_action(true)
end
