require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

RSpec.configure do |config|
  config.color = true
end

at_exit { ChefSpec::Coverage.report! }
