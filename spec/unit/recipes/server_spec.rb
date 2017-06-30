require 'spec_helper'

describe 'graylog2::server' do
  context 'on an empty environment' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new.converge('graylog2::server')
    end

    it 'raise an error an informs the user to set at least password_secret and root_password_sha2' do
      expect { chef_run }.to raise_error
    end
  end

  context 'when the cookbook installs Graylog on a Ubuntu system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.normal['graylog2']['password_secret'] = 'password_hash'
        node.normal['graylog2']['root_password_sha2'] = 'salt'
      end.converge('graylog2::server')
    end

    it 'installs the graylog-server package' do
      expect(chef_run).to install_package 'graylog-server'
    end

    it 'create node-id file' do
      expect(chef_run).to run_ruby_block 'create node-id if needed'
    end

    it 'restart Graylog server service' do
      expect(chef_run).to enable_service 'graylog-server'
    end

    it 'creates a server configuration file' do
      expect(chef_run).to render_file('/etc/graylog/server/server.conf')
    end
    it 'creates a default environment file' do
      expect(chef_run).to render_file('/etc/default/graylog-server')
    end
    it 'creates a logging configuration' do
      expect(chef_run).to render_file('/etc/graylog/server/log4j2.xml')
    end
  end

  context 'when the cookbook installs Graylog on a Centos system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '6.7'
      ) do |node|
        node.normal['graylog2']['password_secret'] = 'password_hash'
        node.normal['graylog2']['root_password_sha2'] = 'salt'
      end.converge('graylog2::server')
    end

    it 'creates a default environment file' do
      expect(chef_run).to render_file('/etc/sysconfig/graylog-server')
    end
  end
end
