name             "torch-graylog2"

maintainer       "Torch GmbH"
maintainer_email "marius@torch.sh"
license          "Apache"
description      "Installs and configures Graylog2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends 'authbind', '>= 0.1.8'

recommends 'java'
recommends 'mongodb'
recommends 'elasticsearch'

supports 'ubuntu'
supports 'debian'
supports 'centos'

provides 'torch-graylog2'
