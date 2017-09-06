require 'spec_helper'

describe 'graylog2::api' do
  shared_examples 'common part' do
    it 'installs mongo driver' do
      expect(chef_run).to install_chef_gem 'mongo'
    end

    it 'installs graylogapi' do
      expect(chef_run).to install_chef_gem 'graylogapi'
    end
  end

  context 'when the recipe run on a Ubuntu system' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04').converge('graylog2::api') }

    it 'not installs gcc package' do
      expect(chef_run).not_to install_package 'gcc'
    end

    it_behaves_like 'common part'
  end

  context 'when the recipe run on a Centos system' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.7').converge('graylog2::api') }

    it 'installs gcc package' do
      expect(chef_run).to install_package 'gcc'
    end

    it_behaves_like 'common part'
  end
end
