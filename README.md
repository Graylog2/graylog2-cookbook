Description
-----------

This _Chef_ cookbook installs and configures the [Graylog2](http://www.graylog2.org) log management system.

It is using the official installation packages provided by [_Torch_](http://www.torch.sh). It needs as requirement an installation of Java, [Elasticsearch](http://www.elasticsearch.org) and [MongoDB](https://www.mongodb.org).

Usage
-----

### Recipes
The cookbook contains several recipes for different installation setups. Pick only the recipes
you need for your environment.

|Recipe     | Description |
|:----------|:------------|
|default    |Setup the Torch package repository|
|server     |Install Graylog2 server|
|web        |Install Graylog2 web interface|
|radio      |Install a Graylog2 radio node|
|authbind   |Give the Graylog2 user access to privileged ports like 514 (only on Ubuntu/Debian)|
|api_access |Use Graylog2 API to setup inputs like 'Syslog UDP'|

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
Graylog2 runs currently with Java 7. To install the correct version set this attribute:

```
  "java": {
    "jdk_version": "7"
```
OpenJDK and Oracle JDK is both fine for Graylog2

You _have_ to use a  certain version of Elasticsearch for every Graylog2 Version, currently
this is 1.3.4. The cluster name should be 'graylog2':

```
  "elasticsearch": {
    "version": "1.3.4",
    "cluster": {
      "name": "graylog2"
    }
  }
```

Graylog2 itself needs a secret for encryption and a hashed password for the root user. By default this user is called _admin_.

You can create the secret with this shell command `pwgen -s 96 1`.

The password can be generated with `echo -n yourpassword | shasum -a 256`

```
  "graylog2": {
    "password_secret": "ZxUahiN48EFVJgzRTzGO2olFRmjmsvzybSf4YwBvn5x1asLUBPe8GHbOQTZ0jzuAB7dzrNPk3wCEH57PCZm23MHAET0G653G",
    "root_password_sha2": "e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e951",
    "server": {
      "java_opts": "-Djava.net.preferIPv4Stack=true"
    },
    "web": {
      "secret": "ZxUahiN48EFVJgzRTzGO2olFRmjmsvzybSf4YwBvn5x1asLUBPe8GHbOQTZ0jzuAB7dzrNPk3wCEH57PCZm23MHAET0G653G"
    }

```

You can take a look into the attributes file under `attributes/default.rb` to get an idea
what can be configured for Graylog2.

### Authbind
Ubuntu/Debian systems allow a user to bind a proccess to a certain privileged port below 1024.
This is called authbind and is supported by this cookbook. So it is possible to let Graylog2 listen on port 514 and act like a normal syslog server. To enable this feature just include
the authbind recipe to your run list `recipe[graylog2::authbind]`. By default the recipe
will give the Graylog2 user permission to bind to port 514 if you need more than that you can
set the attribute `default.graylog2[:authorized_ports]` to an array of allowed ports.

### API access
In order to access the API of Graylog2 we provide a LWRP to do so. At the moment we only support
the creation of inputs but the LWRP is easy to extend. You can use the provider in your own
recipe like this:

Include `recipe[graylog2::api_access]` to your run list.

```
graylog2_inputs "syslog udp" do
input '{ "title": "syslog", "type":"org.graylog2.inputs.syslog.udp.SyslogUDPInput", "creator_user_id":"admin", "global": true, "configuration": { "port": 1514, "allow_override_date": true, "bind_address": "0.0.0.0", "store_full_message": true, "recv_buffer_size": 1048576 } }'
end
```

or you can put the same JSON into an array and set it as an attribute:

```
"graylog2": {
    "inputs": ["{ \"title\": \"syslog\", \"type\":\"org.graylog2.inputs.syslog.udp.SyslogUDPInput\", \"creator_user_id\":\"admin\", \"global\": true, \"configuration\": { \"port\": 1514, \"allow_override_date\": true, \"bind_address\": \"0.0.0.0\", \"store_full_message\": true, \"recv_buffer_size\": 1048576 } }"]
}
```

License
-------

Author: Marius Sturm (<marius@torch.sh>) and [contributors](http://github.com/graylog2/torch-graylog2-cookbook/graphs/contributors)

License: Apache 2.0
