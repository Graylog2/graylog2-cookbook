require 'spec_helper'

describe 'graylog2::default' do
  context 'when the cookbook prepares a Ubuntu system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'ubuntu',
        version: '20.04'
      ) do |node|
        node.normal['graylog2']['major_version'] = '4.1'
      end.converge('java_test').converge('graylog2::default')
    end

    it 'installs https support for apt' do
      expect(chef_run).to install_package 'apt-transport-https'
    end

    it 'installs the repository package' do
      expect(chef_run).to install_package 'graylog-4.1-repository_latest.deb'
    end
  end

  context 'when the cookbook prepares a Centos system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '8'
      ) do |node|
        node.normal['graylog2']['major_version'] = '4.1'
      end.converge('java_test').converge('graylog2::default')
    end

    it 'installs the repository package' do
      expect(chef_run).to install_package 'graylog-4.1-repository_latest.rpm'
    end
  end

  context 'when the Java installation is not compatible' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '8'
      ) do |node|
        node.normal['graylog2']['major_version'] = '4.1'
        node.normal['java_version'] = '7'
      end.converge('java_test').converge('graylog2::default')
    end

    it 'raise an error and inform the user about the wrong version' do
      expect { chef_run }.to raise_error("Java version needs to be >= 8 and <= 11")
    end
  end
end
