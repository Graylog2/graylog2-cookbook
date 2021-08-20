require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end

at_exit { ChefSpec::Coverage.report! }
