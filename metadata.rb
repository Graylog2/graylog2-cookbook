name             "graylog2"

maintainer       "Torch GmbH"
maintainer_email "marius@torch.sh"
license          "Apache 2.0"
description      "Installs and configures Graylog2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.4"

depends 'authbind', '>= 0.1.8'

recommends 'java'
recommends 'mongodb'
recommends 'elasticsearch'

supports 'ubuntu'
supports 'debian'
supports 'centos'

provides 'graylog2'
