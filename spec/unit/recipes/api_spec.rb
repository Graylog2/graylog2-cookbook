require 'spec_helper'

describe 'graylog2::api' do
  context 'on an empty environment' do
    include_context 'empty'

    let(:chef_run) { runner.converge('graylog2::api') }

    it 'raise an error and informs the user to set admin_access_token' do
      expect { chef_run }.to raise_error
    end
  end

  shared_examples 'common' do
    it 'installs mongo driver' do
      expect(chef_run).to install_chef_gem 'mongo'
    end

    it 'installs graylogapi' do
      expect(chef_run).to install_chef_gem 'graylogapi'
    end

    it 'set token' do
      expect(chef_run).to create_admin_token 'testtoken'
    end

    it 'check api' do
      expect(chef_run).to check_api 'http://0.0.0.0:9000/api/'
    end
  end

  context 'when the recipe run on a Ubuntu system' do
    include_context 'ubuntu'

    let(:chef_run) do
      runner.node.normal['graylog2']['rest']['admin_access_token'] = 'testtoken'
      runner.node.normal['graylog2']['rest']['listen_url'] = 'http://0.0.0.0:9000/api/'

      runner.converge('graylog2::api')
    end

    it 'not installs gcc package' do
      expect(chef_run).not_to install_package 'gcc'
    end

    it_behaves_like 'common'
  end

  context 'when the recipe run on a Centos system' do
    include_context 'centos'

    let(:chef_run) do
      runner.node.normal['graylog2']['rest']['admin_access_token'] = 'testtoken'
      runner.node.normal['graylog2']['rest']['listen_url'] = 'http://0.0.0.0:9000/api/'

      runner.converge('graylog2::api')
    end

    it 'installs gcc package' do
      expect(chef_run).to install_package 'gcc'
    end

    it_behaves_like 'common'
  end
end
