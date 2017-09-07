require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

RSpec.configure do |config|
  config.color = true
end

RSpec.shared_context 'ubuntu' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04') }
end

RSpec.shared_context 'centos' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.7') }
end

RSpec.shared_context 'empty' do
  let(:runner) { ChefSpec::ServerRunner.new }
end

at_exit { ChefSpec::Coverage.report! }
