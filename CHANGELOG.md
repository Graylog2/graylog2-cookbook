Graylog Chef Cookbook Changes
==============================

## 2.3.0

* Bump to Graylog 2.3.0
* Added ES HTTP parameter
* Renamed ES discovery search attributes

## 2.1.4

* Bump to Graylog 2.1.1

## 2.1.3

* Allow to configure alternative repository
* Update attributes

## 2.1.2

* Fix repository update on Debian/Ubuntu systems

## 2.1.1

* Bump to GL 2.1.0
* Add web_endpoint_uri
* Fix tests

## 2.1.0

* Replace collector recipe with collector_sidecar
* Update log4j configuration
* Test against Centos 7 and Dedian 8

## 2.0.5

* Fix collector installation

## 2.0.4

* Remove unused ES property elasticsearch_discovery_zen_ping_multicast_enabled
* Server log file pattern changed to keep the correct number of rotated files

## 2.0.3

* Bump to Graylog 2.0.3
* cluster master is now explicitly configurable
* Fixed server start after reboot on Ubuntu systems

## 2.0.2

* Bump to Graylog 2.0.1

## 2.0.1

* Extend tests suite

## 2.0.0

* Major update, please read the Graylog upgrade guide before applying this version
  http://docs.graylog.org/en/2.0/pages/upgrade.html
* The web interface cookbook was removed due to architectual changes in Graylog
* The collector is now deprecated and will be replaced by the Graylog Sidecar in the future
  https://github.com/Graylog2/collector-sidecar
* Added unit tests

## 1.2.2

* Fix collector standalone mode

## 1.2.1

* bump to GL 1.2.1
* create recursive directories for log files
* force repo package installation

## 1.2.0

* bump to GL 1.2.0
* update server configuration attributes
* add hard dependency to `java` cookbook to cleanly manage Java version

## 1.1.6

* make JAVA path configurable
* bump to GL 1.1.6

## 1.1.5

* fix web cluster search
* bump to GL 1.1.5

## 1.1.2

* fix backwards compartibility with Graylog 1.0

## 1.1.1

* Update to bug-fix release 1.1.1

## 1.1.0

* Update to Graylog 1.1.0
* add new attributes for 1.1.0
* introduce foodcritic and rubocop

## 1.0.5

* add position parameter to dashboard provider

## 1.0.4

* Update Graylog version to 1.0.2
* add parameters `alert_conditions` and `alarm_callbacks` to streams provider.
  Both in combination can be used to create stream alerts automatically.
  Take a look into `.kitchen.yml` for a working json example

## 1.0.3

* Update Graylog version to 1.0.1
* Deal with updated configuration in graylog packages on Ubuntu/Debian

## 1.0.2

* elasticsearch-http-enabled is not fixed set to false anymore
* configurable quotation marks for server secrets to allow full server replacement
* append port 9300 to Elasticsearch lookups to minimize discovery failures

## 1.0.1

* reduce file permissions for Graylog config files
* fix empty string for 'graylog2.appender.host' in web.conf

## 1.0.0

* Update Graylog version to 1.0.0
* explicit include of 'authbind' in graylog2::authbind
* improve error handling for api access
* mandatory secrets for server and web interrupt chef run if they are not set
* allow secrets to be set through attributes or an encrypted data bag 'secrets/graylog'
* support chef search for nodes to set up unicast discovery

## 0.3.8 (2015-01-14)

* Bump to 0.92.4
* Restart Graylog server + web interface on package update

## 0.3.7 (2015-01-05)

* Removed dependency on default.rb, you can now use only single parts of the cookbook

## 0.3.6 (2014-12-23)

* Update Graylog2 version to 0.92.3

## 0.3.5 (2014-12-12)

* Update Graylog2 version to 0.92.1

## 0.3.4 (2014-12-01)

* Update Graylog2 version to 0.92.0
* Add new configuration parameters for time based retention and SSL/TLS REST API

## 0.3.3 (2014-11-07)

* Update Graylog2 version to 0.91.3
