node.default[:graylog2] ||= {}
node.default[:mongodb]  ||= {}

# General
default.graylog2[:server][:version] = '0.20.6-1'
default.graylog2[:web][:version]    = '0.20.6-1'
default.graylog2[:radio][:versioo]  = '0.20.6-1'
default.graylog2[:user]             = 'graylog2'
default.graylog2[:group]            = 'graylog2'
default.graylog2[:root_username]    = 'admin'

# SHAs
default.graylog2[:password_secret]    = nil
default.graylog2[:root_password_sha2] = nil

# Paths
default.graylog2[:node_id_file] = '/etc/graylog2/server/node-id'
default.graylog2[:plugin_dir]   = '/usr/share/graylog2-server/plugin'

# Network
default.graylog2[:http_proxy_uri] = nil

# Rest
default.graylog2[:rest][:listen_uri]    = 'http://127.0.0.1:12900/'
default.graylog2[:rest][:transport_uri] = 'http://127.0.0.1:12900/'
default.graylog2[:rest][:enable_cors]   = nil
default.graylog2[:rest][:enable_gzip]   = nil

# Elasticsearch
default.graylog2[:elasticsearch][:config_file]           = '/etc/graylog2-elasticsearch.yml'
default.graylog2[:elasticsearch][:max_docs_per_index]    = 20000000
default.graylog2[:elasticsearch][:max_number_of_indices] = 20
default.graylog2[:elasticsearch][:shards]                = 4
default.graylog2[:elasticsearch][:replicas]              = 0
default.graylog2[:elasticsearch][:retention_strategy]    = 'delete'
default.graylog2[:elasticsearch][:index_prefix]          = 'graylog2'
default.graylog2[:elasticsearch][:cluster_name]          = 'graylog2'
default.graylog2[:elasticsearch][:node_name]             = 'graylog2-server'
default.graylog2[:elasticsearch][:http_enabled]          = false
default.graylog2[:elasticsearch][:cluster_discovery_timeout]            = 5000
default.graylog2[:elasticsearch][:discovery_zen_ping_multicast_enabled] = false
default.graylog2[:elasticsearch][:discovery_zen_ping_unicast_hosts]     = '127.0.0.1:9300'
default.graylog2[:elasticsearch][:network_host]          = nil
default.graylog2[:elasticsearch][:network_bind_host]     = nil
default.graylog2[:elasticsearch][:network_publish_host]  = nil
default.graylog2[:elasticsearch][:analyzer]              = 'standard'
default.graylog2[:elasticsearch][:output_batch_size]     = 25
default.graylog2[:elasticsearch][:output_flush_interval] = 1
default.graylog2[:elasticsearch][:transport_tcp_port]    = 9350

# MongoDb
default.graylog2[:mongodb][:useauth]         = false
default.graylog2[:mongodb][:user]            = nil
default.graylog2[:mongodb][:password]        = nil
default.graylog2[:mongodb][:host]            = '127.0.0.1'
default.graylog2[:mongodb][:replica_set]     = nil
default.graylog2[:mongodb][:database]        = 'graylog2'
default.graylog2[:mongodb][:port]            = 27017
default.graylog2[:mongodb][:max_connections] = 100
default.graylog2[:mongodb][:threads_allowed_to_block_multiplier] = 5

# Search
default.graylog2[:allow_leading_wildcard_searches] = false
default.graylog2[:allow_highlighting]              = false

# Streams
default.graylog2[:stream_processing_timeout]    = 2000
default.graylog2[:stream_processing_max_faults] = 3

# Rewrites
default.graylog2[:rules_file] = nil

# Buffer
default.graylog2[:processbuffer_processors] = 5
default.graylog2[:outputbuffer_processors]  = 3
default.graylog2[:processor_wait_strategy]  = 'blocking'
default.graylog2[:ring_size]                = 1024

# Cluster
default.graylog2[:ip_of_master] = node.ipaddress
default.graylog2[:lb_recognition_period_seconds] = 3

# Email transport
default.graylog2[:transport_email_enabled]  = false
default.graylog2[:transport_email_hostname] = 'mail.example.com'
default.graylog2[:transport_email_port]     = 587
default.graylog2[:transport_email_use_auth] = true
default.graylog2[:transport_email_use_tls]  = true
default.graylog2[:transport_email_use_ssl]  = true
default.graylog2[:transport_email_auth_username]     = 'you@example.com'
default.graylog2[:transport_email_auth_password]     = 'secret'
default.graylog2[:transport_email_subject_prefix]    = '[graylog2]'
default.graylog2[:transport_email_from_email]        = 'graylog2@example.com'
default.graylog2[:transport_email_web_interface_url] = nil

# Logging
default.graylog2[:server][:log_file]      = "/var/log/graylog2-server/server.log"
default.graylog2[:server][:log_max_size]  = "10MB"
default.graylog2[:server][:log_max_index] = 10
default.graylog2[:server][:log_pattern]   = "%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX} %-5p [%c{1}] %m%n"
default.graylog2[:server][:log_level_application] = "warn"
default.graylog2[:server][:log_level_ldap]        = "error"
default.graylog2[:server][:log_level_root]        = "warn" 

# JVM
default.graylog2[:server][:java_opts] = ''
default.graylog2[:server][:args]      = ''

# Experimental
default.graylog2[:dead_letters_enabled] = false

# Web
default.graylog2[:web][:server_backends]  = "\"http://127.0.0.1:12900/\""
default.graylog2[:web][:secret]           = ''
default.graylog2[:web][:timezone]         = "Europe/Berlin"
default.graylog2[:web][:field_list_limit] = 100
default.graylog2[:web][:context]          = nil
default.graylog2[:web][:log_file]         = "/var/log/graylog2-web/application.log"
default.graylog2[:web][:log_file_pattern] = "/var/log/graylog2-web/application.%d{yyyy-MM-dd}.log"
default.graylog2[:web][:history]          = 30
default.graylog2[:web][:log_pattern]      = "%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX} - [%level] - from %logger in %thread %n%message%n%xException%n"
default.graylog2[:web][:log_level]        = "INFO"

# Radio
default.graylog2[:radio][:node_id_file]              = "/etc/graylog2/radio/node-id"
default.graylog2[:radio][:transport_type]            = "amqp"
default.graylog2[:radio][:server_uri]                = "http://127.0.0.1:12900/"
default.graylog2[:radio][:rest][:listen_uri]         = "http://127.0.0.1:12950/"
default.graylog2[:radio][:rest][:transport_uri]      = nil
default.graylog2[:radio][:amqp][:broker_hostname]    = "localhost"
default.graylog2[:radio][:amqp][:broker_port]        = 5672
default.graylog2[:radio][:amqp][:broker_vhost]       = nil
default.graylog2[:radio][:amqp][:broker_username]    = nil
default.graylog2[:radio][:amqp][:broker_password]    = nil
default.graylog2[:radio][:kafka][:brokers]           = nil
default.graylog2[:radio][:kafka][:producer_type]     = nil
default.graylog2[:radio][:kafka][:batch_size]        = nil
default.graylog2[:radio][:kafka][:batch_max_wait_ms] = nil
default.graylog2[:radio][:kafka][:required_acks]     = nil
default.graylog2[:radio][:processbuffer_processors]  = 5
default.graylog2[:radio][:processor_wait_strategy]   = "blocking"
default.graylog2[:radio][:processor_wait_strategy]   = 1024
default.graylog2[:radio][:log_file]                  = "/var/log/graylog2-radio/radio.log"
default.graylog2[:radio][:log_max_size]              = "10MB"
default.graylog2[:radio][:log_max_index]             = 10
default.graylog2[:radio][:log_pattern]               = "%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX} %-5p [%c{1}] %m%n"
default.graylog2[:radio][:log_level_application]     = "warn"
default.graylog2[:radio][:log_level_ldap]            = "error"
default.graylog2[:radio][:log_level_root]            = "warn"
