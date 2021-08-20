name             'java_test'
maintainer       'Graylog Inc.'
maintainer_email 'hello@graylog.com'
license          'Apache 2.0'
description      'A wrapper cookbook used for Graylog testing'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'apt'
depends 'yum'
depends 'java', '~>9.0.0'
