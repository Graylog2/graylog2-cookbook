Description
-----------
Unit tests [![Build Status](https://travis-ci.org/Graylog2/graylog2-cookbook.svg)](https://travis-ci.org/Graylog2/graylog2-cookbook)
Integration tests [![Build Status](https://jenkins-01.eastus.cloudapp.azure.com/job/graylog2-cookbook/badge/icon)](https://jenkins-01.eastus.cloudapp.azure.com/job/graylog2-cookbook/)

This _Chef_ cookbook installs and configures the [Graylog](http://www.graylog.org) log management system.

It is using the official installation packages provided by [_Graylog, Inc._](http://www.graylog.com). It needs as requirement an installation of Java, [Elasticsearch](http://www.elasticsearch.org) and [MongoDB](https://www.mongodb.org).

Usage
-----

### Quickstart
To give this cookbook a try simply use the Kitchen test suite.

```
kitchen setup oracle-ubuntu-1404
open http://localhost:9000
Login with admin/admin
```

### Recipes
The cookbook contains several recipes for different installation setups. Pick only the recipes
you need for your environment.

|Recipe             | Description |
|:------------------|:------------|
|default            |Setup the Graylog package repository|
|server             |Install Graylog server|
|authbind           |Give the Graylog user access to privileged ports like 514 (only on Ubuntu/Debian)|
|collector_sidecar  |Install Graylog's collector sidecar|

In a minimal setup you need at least the _default_ and _server_ recipes. Combined with
MongoDB and Elasticsearch, a run list might look like this:

```
run_list "recipe[java]",
         "recipe[elasticsearch]",
         "recipe[mongodb]",
         "recipe[graylog2]",
         "recipe[graylog2::server]"
```

Keep in mind that Graylog needs Elasticsearch 2.x+, what can be installed with the Elasticsearch cookbook version < 3.0.0

### Attributes
Graylog runs currently with Java 8. To install the correct version set this attribute:

#### Oracle

```json
  "java": {
    "jdk_version": "8",
    "install_flavor": "oracle",
    "oracle": {
      "accept_oracle_download_terms": true
    }
  }
```

#### OpenJDK

```json
  "java": {
    "jdk_version": "8",
    "install_flavor": "openjdk"
  }
```

OpenJDK and Oracle JDK are both fine for Graylog. Note that you must accept
Oracle's download terms if you select the oracle install flavor.

On some platforms you need to accept terms to install OpenJDK too. See the [java
cookbook's README](https://supermarket.chef.io/cookbooks/java) for more
information.

You _have_ to use a  certain version of Elasticsearch for every Graylog Version, currently
this is 5.5.1. The cluster name should be 'graylog':

```json
  "elasticsearch": {
    "version": "5.5.1",
    "cluster": {
      "name": "graylog"
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
  }
}
```

You can take a look into the attributes file under `attributes/default.rb` to get an idea
what can be configured for Graylog.

### Node discovery
The cookbook is able to use Chef's search to find Elasticsearch and other Graylog nodes. To configure
a dynamic cluster set the following attributes:

#### Elasticsearch discovery

```json
  "graylog2": {
    "elasticsearch": {
      "node_search_query": "role:elasticsearch",
      "node_search_attribute": "ipaddress"
    }
  }
```

If you have multiple server one need to be set as a master, use this attribute to do so

```
default.graylog2[:ip_of_master] = node.ipaddress
```

### Running behind a NAT'ed public IP

If you are running Graylog behind a NAT, you will need to forward port 9000 to the outside as well as:

```json
  "graylog2": {
      "rest": {
        "listen_uri": "http://0.0.0.0:9000/api/"
      },
      "web": {
        "listen_uri": "http://0.0.0.0:9000/",
        "endpoint_uri": "http://<public facing IP>:9000/api"
      }
  }
```

See [graylog docs](http://docs.graylog.org/en/2.3/pages/configuration/web_interface.html#single-or-separate-listeners-for-web-interface-and-rest-api) for more info.

### Authbind

Ubuntu/Debian systems allow a user to bind a proccess to a certain privileged port below 1024.
This is called authbind and is supported by this cookbook. So it is possible to let Graylog listen on port 514 and act like a normal syslog server.
To enable this feature include the [authbind](https://supermarket.chef.io/cookbooks/authbind) cookbook to your run list and also the recipe
`recipe[graylog2::authbind]` from this cookbook.
By default the recipe will give the Graylog user permission to bind to port 514 if you need more than that you can
set the attribute `default.graylog2[:authorized_ports]` to an array of allowed ports.

### Development and testing

The cookbook comes with unit and integration tests for Ubuntu/Debian/CentOS. You can run them by using Rake and Test Kitchen.

Unit tests:

```
  $ bundle exec rake spec
```

Integration tests:

```
  $ kitchen list
  $ kitchen converge oracle-ubuntu-1404
  $ kitchen verify oracle-ubuntu-1404
```

Additionally you can verify the coding style by running RoboCop and Foodcritic.

Verify Ruby syntax with RuboCop:

```
  $ bundle exec rake style:ruby
```

Verify Chef syntax with Foodcritic:

```
  $ bundle exec rake style:chef
```

License
-------

Author: Marius Sturm (<marius@graylog.com>) and [contributors](http://github.com/graylog2/graylog2-cookbook/graphs/contributors)

License: Apache 2.0
