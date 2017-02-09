require 'spec_helper'

describe 'graylog2::default' do
  context 'when the cookbook prepares a Ubuntu system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.normal['java']['jdk_version'] = '8'
        node.normal['graylog2']['major_version'] = '2.2'
      end.converge('graylog2::default')
    end

    it 'installs https support for apt' do
      expect(chef_run).to install_package 'apt-transport-https'
    end

    it 'installs the repository package' do
      expect(chef_run).to install_package 'graylog-2.2-repository_latest.deb'
    end
  end

  context 'when the cookbook prepares a Centos system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '6.7'
      ) do |node|
        node.normal['java']['jdk_version'] = '8'
        node.normal['graylog2']['major_version'] = '2.2'
      end.converge('graylog2::default')
    end

    it 'installs the repository package' do
      expect(chef_run).to install_package 'graylog-2.2-repository_latest.rpm'
    end
  end

  context 'when the Java installation is not compatible' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['java']['jdk_version'] = '7'
      end.converge('graylog2::default')
    end

    it 'raise an error and inform the user about the wrong version' do
      expect { chef_run }.to raise_error
    end
  end
end
