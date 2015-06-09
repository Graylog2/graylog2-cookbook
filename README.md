Description
-----------

This _Chef_ cookbook installs and configures the [Graylog](http://www.graylog.org) log management system.

It is using the official installation packages provided by [_Graylog, Inc._](http://www.graylog.com). It needs as requirement an installation of Java, [Elasticsearch](http://www.elasticsearch.org) and [MongoDB](https://www.mongodb.org).

Usage
-----

### Quickstart
To give this cookbook a try simply use the Kitchen test suite.

```
kitchen setup default-ubuntu-1404
open http://localhost:9000
Login with admin/admin
```

### Recipes
The cookbook contains several recipes for different installation setups. Pick only the recipes
you need for your environment.

|Recipe     | Description |
|:----------|:------------|
|default    |Setup the Graylog package repository|
|server     |Install Graylog server|
|web        |Install Graylog web interface|
|radio      |Install a Graylog radio node|
|authbind   |Give the Graylog user access to privileged ports like 514 (only on Ubuntu/Debian)|
|api_access |Use Graylog API to setup inputs like 'Syslog UDP'|
|collector  |Install Graylog's collector (Experimental)|

In a minimal setup you need at least the _default_, _server_ and _web_ recipes. Combined with
MongoDB and Elasticsearch, a run list might look like this:

```
run_list "recipe[java]",
         "recipe[elasticsearch]",
         "recipe[mongodb]",
         "recipe[graylog2]",
         "recipe[graylog2::server]",
         "recipe[graylog2::web]"
```

### Attributes
Graylog runs currently with Java 8. To install the correct version set this attribute:

```json
  "java": {
    "jdk_version": "8",
    "install_flavor": "oracle",
    "oracle": {
      "accept_oracle_download_terms": true
    }
  }
```

OpenJDK and Oracle JDK are both fine for Graylog, but the [Java cookbook](https://supermarket.chef.io/cookbooks/java) only supports Oracle's Java 8. Note that you must accept Oracle's download terms.

You _have_ to use a  certain version of Elasticsearch for every Graylog Version, currently
this is 1.5.2. The cluster name should be 'graylog2':

```json
  "elasticsearch": {
    "version": "1.5.2",
    "cluster": {
      "name": "graylog2"
    }
  }
```

Graylog itself needs a secret for encryption and a hashed password for the root user. By default this user is called _admin_.

You can create the secret with this shell command `pwgen -s 96 1`.

The password can be generated with `echo -n yourpassword | shasum -a 256 | awk '{print $1}'`

```json
  "graylog2": {
    "password_secret": "ZxUahiN48EFVJgzRTzGO2olFRmjmsvzybSf4YwBvn5x1asLUBPe8GHbOQTZ0jzuAB7dzrNPk3wCEH57PCZm23MHAET0G653G",
    "root_password_sha2": "e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e951",
    "server": {
      "java_opts": "-Djava.net.preferIPv4Stack=true"
    },
    "web": {
      "secret": "ZxUahiN48EFVJgzRTzGO2olFRmjmsvzybSf4YwBvn5x1asLUBPe8GHbOQTZ0jzuAB7dzrNPk3wCEH57PCZm23MHAET0G653G"
    }
  }
```

Alternatively you can create an encrypted data bag and store the secrets there. The data should be called
'secrets' with an item 'graylog'.

```shell
knife data bag create --secret-file ~/.chef/encrypted_data_bag_secret secrets graylog

{
  "id": "graylog",
  "server": {
    "root_password_sha2": "<root password as sha256>",
    "password_secret": "<random string as encryption salt>"
  },
  "web": {
    "secret": "<random string as encryption salt>"
  }
}
```

You can take a look into the attributes file under `attributes/default.rb` to get an idea
what can be configured for Graylog.

### Node discovery
The cookbook is able to use Chef's search to find Elasticsearch and other Graylog nodes. To configure
a dynamic cluster set the following attributes:

#### Elasticsearch discovery
```ruby
'graylog2'=> {
  'elasticsearch' => {
    'unicast_search_query' => 'role:elasticsearch',
    'search_node_attribute' => 'ipaddress'
  }
}
```

#### Graylog server discovery
```ruby
'graylog2'=> {
  'web' => {
    'server_search_query' => 'role:graylog-server',
    'search_node_attribute' => 'ipaddress'
  }
}
```

One server needs to be set as a master, use this attribute to do so

```
default.graylog2[:ip_of_master] = node.ipaddress
```

### Authbind

Ubuntu/Debian systems allow a user to bind a proccess to a certain privileged port below 1024.
This is called authbind and is supported by this cookbook. So it is possible to let Graylog listen on port 514 and act like a normal syslog server.
To enable this feature include the [authbind](https://supermarket.chef.io/cookbooks/authbind) cookbook to your run list and also the recipe
`recipe[graylog2::authbind]` from this cookbook.
By default the recipe will give the Graylog user permission to bind to port 514 if you need more than that you can
set the attribute `default.graylog2[:authorized_ports]` to an array of allowed ports.

### API access

In order to access the API of Graylog we provide a LWRP to do so. At the moment we only support
the creation of inputs but the LWRP is easy to extend. You can use the provider in your own
recipe like this:

Include `recipe[graylog2::api_access]` to your run list.

```ruby
graylog2_inputs "syslog udp" do
  input '{ "title": "syslog", "type":"org.graylog2.inputs.syslog.udp.SyslogUDPInput", "global": true, "configuration": { "port": 1514, "allow_override_date": true, "bind_address": "0.0.0.0", "store_full_message": true, "recv_buffer_size": 1048576 } }'
end
```

or you can put the same JSON into an array and set it as an attribute:

```json
"graylog2": {
  "inputs": ["{ \"title\": \"syslog\", \"type\":\"org.graylog2.inputs.syslog.udp.SyslogUDPInput\", \"global\": true, \"configuration\": { \"port\": 1514, \"allow_override_date\": true, \"bind_address\": \"0.0.0.0\", \"store_full_message\": true, \"recv_buffer_size\": 1048576 } }"]
}
```

License
-------

Author: Marius Sturm (<marius@graylog.com>) and [contributors](http://github.com/graylog2/graylog2-cookbook/graphs/contributors)

License: Apache 2.0
