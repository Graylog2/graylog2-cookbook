node.default[:graylog2] ||= {}
node.default[:mongodb] ||= {}

# General
default.graylog2[:major_version]             = '1.2'
default.graylog2[:server][:version]          = '1.2.0-5'
default.graylog2[:web][:version]             = '1.2.0-5'
default.graylog2[:radio][:version]           = '1.2.0-5'
default.graylog2[:collector][:version]       = '0.4.1'
default.graylog2[:root_username]             = 'admin'
default.graylog2[:root_email]                = nil
default.graylog2[:root_timezone]             = nil
default.graylog2[:restart]                   = 'delayed'
default.graylog2[:no_retention]              = nil
default.graylog2[:disable_sigar]             = nil
default.graylog2[:enable_metrics_collection] = nil
default.graylog2[:dashboard_widget_default_cache_time] = '10s'
default.graylog2[:secrets_data_bag]          = 'secrets'

# Users
default.graylog2[:server][:user]  = 'graylog'
default.graylog2[:server][:group] = 'graylog'
default.graylog2[:web][:user]     = 'graylog-web'
default.graylog2[:web][:group]    = 'graylog-web'
default.graylog2[:radio][:user]   = 'graylog-radio'
default.graylog2[:radio][:group]  = 'graylog-radio'
default.graylog2[:collector][:user]   = 'graylog-collector'
default.graylog2[:collector][:group]  = 'graylog-collector'

# Generated API resources
default.graylog2[:inputs] = nil
default.graylog2[:streams] = nil
default.graylog2[:dashboards] = nil

# SHAs
default.graylog2[:password_secret]              = nil # pwgen -s 96 1
default.graylog2[:password_secret_enclose_char] = '"'
default.graylog2[:root_password_sha2]           = nil # echo -n yourpassword | shasum -a 256

# Paths
default.graylog2[:node_id_file] = '/etc/graylog/server/node-id'
default.graylog2[:plugin_dir]   = '/usr/share/graylog-server/plugin'

# Network
default.graylog2[:http_proxy_uri]   = nil
default.graylog2[:authorized_ports] = 514

# Rest
default.graylog2[:rest][:listen_uri]              = 'http://0.0.0.0:12900'
default.graylog2[:rest][:transport_uri]           = nil
default.graylog2[:rest][:enable_cors]             = nil
default.graylog2[:rest][:enable_gzip]             = nil
default.graylog2[:rest][:admin_access_token]      = nil # pwgen -s 96 1
default.graylog2[:rest][:enable_tls]              = nil
default.graylog2[:rest][:tls_cert_file]           = nil
default.graylog2[:rest][:tls_key_file]            = nil
default.graylog2[:rest][:tls_key_password]        = nil
default.graylog2[:rest][:max_chunk_size]          = nil
default.graylog2[:rest][:max_header_size]         = nil
default.graylog2[:rest][:max_initial_line_length] = nil
default.graylog2[:rest][:thread_pool_size]        = nil
default.graylog2[:rest][:worker_threads_max_pool_size] = nil

# Elasticsearch
default.graylog2[:elasticsearch][:config_file]           = '/etc/graylog-elasticsearch.yml'
default.graylog2[:elasticsearch][:max_docs_per_index]    = 20000000
default.graylog2[:elasticsearch][:max_size_per_index]    = 1073741824
default.graylog2[:elasticsearch][:max_time_per_index]    = '1d'
default.graylog2[:elasticsearch][:max_number_of_indices] = 20
default.graylog2[:elasticsearch][:shards]                = 4
default.graylog2[:elasticsearch][:replicas]              = 0
default.graylog2[:elasticsearch][:retention_strategy]    = 'delete'
default.graylog2[:elasticsearch][:rotation_strategy]     = 'count'
default.graylog2[:elasticsearch][:index_prefix]          = 'graylog2'
default.graylog2[:elasticsearch][:cluster_name]          = 'graylog2'
default.graylog2[:elasticsearch][:node_name]             = 'graylog2-server'
default.graylog2[:elasticsearch][:http_enabled]          = false
default.graylog2[:elasticsearch][:discovery_zen_ping_multicast_enabled] = false
default.graylog2[:elasticsearch][:discovery_zen_ping_unicast_hosts]     = '127.0.0.1:9300'
default.graylog2[:elasticsearch][:unicast_search_query]  = nil
default.graylog2[:elasticsearch][:search_node_attribute] = nil
default.graylog2[:elasticsearch][:network_host]          = nil
default.graylog2[:elasticsearch][:network_bind_host]     = nil
default.graylog2[:elasticsearch][:network_publish_host]  = nil
default.graylog2[:elasticsearch][:analyzer]              = 'standard'
default.graylog2[:elasticsearch][:output_batch_size]     = 500
default.graylog2[:elasticsearch][:output_flush_interval] = 1
default.graylog2[:elasticsearch][:output_fault_count_threshold] = 5
default.graylog2[:elasticsearch][:output_fault_penalty_seconds] = 30
default.graylog2[:elasticsearch][:transport_tcp_port]           = 9350
default.graylog2[:elasticsearch][:disable_version_check]        = nil
default.graylog2[:elasticsearch][:disable_index_optimization]   = nil
default.graylog2[:elasticsearch][:index_optimization_max_num_segments] = nil
default.graylog2[:elasticsearch][:disable_index_range_calculation]     = nil

# MongoDb
# Use these settings for Graylog <= 1.0
default.graylog2[:mongodb][:useauth]     = false
default.graylog2[:mongodb][:user]        = nil
default.graylog2[:mongodb][:password]    = nil
default.graylog2[:mongodb][:host]        = '127.0.0.1'
default.graylog2[:mongodb][:replica_set] = nil
default.graylog2[:mongodb][:database]    = 'graylog2'
default.graylog2[:mongodb][:port]        = 27017
# Use a URI for Graylog >= 1.1
default.graylog2[:mongodb][:uri] = 'mongodb://127.0.0.1:27017/graylog2'
default.graylog2[:mongodb][:max_connections] = 100
default.graylog2[:mongodb][:threads_allowed_to_block_multiplier] = 5

# Search
default.graylog2[:allow_leading_wildcard_searches] = false
default.graylog2[:allow_highlighting]              = false

# Streams
default.graylog2[:stream_processing_max_faults] = 3

# Rewrites
default.graylog2[:rules_file] = nil

# Buffer
default.graylog2[:processbuffer_processors]  = 5
default.graylog2[:outputbuffer_processors]   = 3
default.graylog2[:async_eventbus_processors] = 2
default.graylog2[:outputbuffer_processor_keep_alive_time]        = 5000
default.graylog2[:outputbuffer_processor_threads_core_pool_size] = 3
default.graylog2[:outputbuffer_processor_threads_max_pool_size]  = 30
default.graylog2[:processor_wait_strategy]   = 'blocking'
default.graylog2[:ring_size]                 = 65536
default.graylog2[:udp_recvbuffer_sizes]      = 1048576
default.graylog2[:inputbuffer_ring_size]     = 65536
default.graylog2[:inputbuffer_processors]    = 2
default.graylog2[:inputbuffer_wait_strategy] = 'blocking'

# Message journal
default.graylog2[:message_journal_enabled]        = true
default.graylog2[:message_journal_dir]            = '/var/lib/graylog-server/journal'
default.graylog2[:message_journal_max_age]        = '12h'
default.graylog2[:message_journal_max_size]       = '5gb'
default.graylog2[:message_journal_flush_age]      = '1m'
default.graylog2[:message_journal_flush_interval] = 1000000
default.graylog2[:message_journal_segment_age]    = '1h'
default.graylog2[:message_journal_segment_size]   = '100mb'

# Timeouts
default.graylog2[:output_module_timeout]     = 10000
default.graylog2[:stale_master_timeout]      = 2000
default.graylog2[:shutdown_timeout]          = 30000
default.graylog2[:stream_processing_timeout] = 2000
default.graylog2[:ldap_connection_timeout]   = 2000
default.graylog2[:api_client_timeout]        = 300
default.graylog2[:http_connect_timeout]      = '5s'
default.graylog2[:http_read_timeout]         = '10s'
default.graylog2[:http_write_timeout]        = '10s'
default.graylog2[:elasticsearch][:cluster_discovery_timeout]       = 5000
default.graylog2[:elasticsearch][:discovery_initial_state_timeout] = '3s'
default.graylog2[:elasticsearch][:request_timeout]                 = '1m'

# Intervals
default.graylog2[:server][:alert_check_interval] = nil

# Cluster
default.graylog2[:ip_of_master]                  = node.ipaddress
default.graylog2[:lb_recognition_period_seconds] = 3
default.graylog2[:web][:server_search_query]     = nil
default.graylog2[:web][:server_search_protocol]  = 'http'
default.graylog2[:web][:server_search_port]      = 12900
default.graylog2[:web][:search_node_attribute]   = nil

# Email transport
default.graylog2[:transport_email_enabled]  = false
default.graylog2[:transport_email_hostname] = 'mail.example.com'
default.graylog2[:transport_email_port]     = 587
default.graylog2[:transport_email_use_auth] = true
default.graylog2[:transport_email_use_tls]  = true
default.graylog2[:transport_email_use_ssl]  = true
default.graylog2[:transport_email_auth_username]     = 'you@example.com'
default.graylog2[:transport_email_auth_password]     = 'secret'
default.graylog2[:transport_email_subject_prefix]    = '[graylog]'
default.graylog2[:transport_email_from_email]        = 'graylog@example.com'
default.graylog2[:transport_email_web_interface_url] = nil

# Logging
default.graylog2[:server][:log_file]      = '/var/log/graylog-server/server.log'
default.graylog2[:server][:log_max_size]  = '10MB'
default.graylog2[:server][:log_max_index] = 10
default.graylog2[:server][:log_pattern]   = "%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX} %-5p [%c{1}] %m%n"
default.graylog2[:server][:log_level_application] = 'warn'
default.graylog2[:server][:log_level_ldap]        = 'error'
default.graylog2[:server][:log_level_root]        = 'warn'

# JVM
default.graylog2[:server][:java_bin] = '/usr/bin/java'
default.graylog2[:server][:java_home] = ''
default.graylog2[:server][:java_opts] = '-Djava.net.preferIPv4Stack=true -Xms1g -Xmx1g -XX:NewRatio=1 -XX:PermSize=128m -XX:MaxPermSize=256m -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow'
default.graylog2[:server][:args]      = ''
default.graylog2[:server][:wrapper]   = ''
default.graylog2[:server][:gc_warning_threshold] = nil
default.graylog2[:radio][:java_opts]  = '-Djava.net.preferIPv4Stack=true -Xms1g -Xmx1g -XX:NewRatio=1 -XX:PermSize=128m -XX:MaxPermSize=256m -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow'
default.graylog2[:radio][:args]       = ''
default.graylog2[:radio][:wrapper]    = ''
default.graylog2[:web][:java_opts]    = '-Djava.net.preferIPv4Stack=true'
default.graylog2[:web][:args]         = ''

# Experimental
default.graylog2[:dead_letters_enabled] = false

# Server
default.graylog2[:server][:override_restart_command] = false
default.graylog2[:server][:additional_options]       = nil

# Web
default.graylog2[:web][:java_bin] = '/usr/bin/java'
default.graylog2[:web][:java_home] = ''
default.graylog2[:web][:listen_address]    = '0.0.0.0'
default.graylog2[:web][:listen_port]       = 9000
default.graylog2[:web][:server_backends]   = nil
default.graylog2[:web][:secret]            = nil
default.graylog2[:web][:timezone]          = 'Europe/Berlin'
default.graylog2[:web][:field_list_limit]  = 100
default.graylog2[:web][:context]           = nil
default.graylog2[:web][:log_file]          = '/var/log/graylog-web/application.log'
default.graylog2[:web][:log_file_pattern]  = '/var/log/graylog-web/application.%d{yyyy-MM-dd}.log'
default.graylog2[:web][:history]           = 30
default.graylog2[:web][:log_pattern]       = "%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX} - [%level] - from %logger in %thread %n%message%n%xException%n"
default.graylog2[:web][:log_level]         = 'INFO'
default.graylog2[:web][:gelf_log][:host]   = nil
default.graylog2[:web][:gelf_log][:source] = nil
default.graylog2[:web][:gelf_log][:send_access]   = nil
default.graylog2[:web][:override_restart_command] = false
default.graylog2[:web][:wrapper]                  = ''
default.graylog2[:web][:additional_options]       = nil

# Radio
default.graylog2[:radio][:java_bin]                  = '/usr/bin/java'
default.graylog2[:radio][:java_home]                 = ''
default.graylog2[:radio][:node_id_file]              = '/etc/graylog/radio/node-id'
default.graylog2[:radio][:transport_type]            = 'amqp'
default.graylog2[:radio][:server_uri]                = nil
default.graylog2[:radio][:rest][:listen_uri]         = nil
default.graylog2[:radio][:rest][:transport_uri]      = nil
default.graylog2[:radio][:amqp][:broker_hostname]    = 'localhost'
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
default.graylog2[:radio][:processor_wait_strategy]   = 'blocking'
default.graylog2[:radio][:log_file]                  = '/var/log/graylog-radio/radio.log'
default.graylog2[:radio][:log_max_size]              = '10MB'
default.graylog2[:radio][:log_max_index]             = 10
default.graylog2[:radio][:log_pattern]               = "%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX} %-5p [%c{1}] %m%n"
default.graylog2[:radio][:log_level_application]     = 'warn'
default.graylog2[:radio][:log_level_ldap]            = 'error'
default.graylog2[:radio][:log_level_root]            = 'warn'
default.graylog2[:radio][:override_restart_command]  = false
default.graylog2[:radio][:additional_options]        = nil

# Collector
default.graylog2[:collector][:java_bin]                     = '/usr/bin/java'
default.graylog2[:collector][:java_home]                    = ''
default.graylog2[:collector][:package_url]                  = "http://packages.graylog2.org/releases/graylog-collector/graylog-collector-#{node.graylog2[:collector][:version]}.tgz"
default.graylog2[:collector][:server_url]                   = 'http://localhost:12900'
default.graylog2[:collector][:id]                           = 'file:/etc/graylog/collector/collector-id'
default.graylog2[:collector][:buffer_size]                  = 128
default.graylog2[:collector][:metrics][:enable_logging]     = 'false'
default.graylog2[:collector][:metrics][:log_duration]       = '60s'
default.graylog2[:collector][:inputs]                       = { 'local-syslog' => { 'type' => 'file', 'path' => '/var/log/syslog', 'charset' => 'utf-8', 'content-splitter' => 'newline' } }
default.graylog2[:collector][:outputs]                      = { 'gelf-tcp' => { 'type' => 'gelf', 'protocol' => 'tcp', 'host' => '127.0.0.1', 'port' => 12201 } }
default.graylog2[:server][:collector_inactive_threshold]    = '1m'
default.graylog2[:server][:collector_expiration_threshold]  = '14d'
