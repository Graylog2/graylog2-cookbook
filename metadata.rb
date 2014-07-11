name             "torch-graylog2"

maintainer       "Torch GmbH"
maintainer_email "marius@torch.sh"
license          "Apache"
description      "Installs and configures Graylog2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends 'ark', '>= 0.9.0'

recommends 'java'
recommends 'monit'

provides 'torch-graylog2'
