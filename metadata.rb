name 'graylog2'
maintainer 'Graylog, Inc.'
maintainer_email 'marius@graylog.com'
source_url 'https://github.com/Graylog2/graylog2-cookbook'
issues_url 'https://github.com/Graylog2/graylog2-cookbook/issues'
license 'Apache 2.0'
description 'Installs and configures Graylog - maintained by Graylog, Inc.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.3.0'

depends 'authbind', '>= 0.1.8'
depends 'java'
depends 'ark'

suggests 'mongodb'
suggests 'elasticsearch', '< 3.0.0'
suggests 'authbind'

supports 'ubuntu'
supports 'debian'
supports 'centos'

provides 'graylog2'
