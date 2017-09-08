property :token, name_property: true

action :create do
  require 'mongo'

  client = Mongo::Client.new(node['graylog2']['mongodb']['uri'])

  if client.cluster.servers.empty?
    raise "Can`t connect to mongodb, please check url #{node['graylog2']['mongodb']['uri']}"
  end

  coll = client[:access_tokens]
  params = { username: node['graylog2']['root_username'],
             NAME: 'graylogapi' }

  tokens = coll.find(params).limit(1)

  if tokens.first.nil?
    coll.insert_one(params.merge(token: token))
  elsif tokens.first['token'] != token
    tokens.update_one('$set' => { token: token })

    Chef::Log.debug('Graylog admin access token was updated')
  else
    Chef::Log.debug('Graylog admin access token is already set - nothing to do')
  end
end
