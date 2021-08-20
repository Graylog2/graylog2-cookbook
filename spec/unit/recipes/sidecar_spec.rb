require 'spec_helper'

RSpec.describe 'graylog2::sidecar' do
  context 'when the cookbook installs graylog-sidecar on a Ubuntu system' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '20.04',
        file_cache_path: '/tmp'
      ) do |node|
        node.normal['graylog2']['sidecar']['version'] = '1.1.0'
        node.normal['graylog2']['sidecar']['release'] = 1
      end.converge('graylog2::sidecar')
    end

    it 'downloads the sidecar repository package' do
      expect(chef_run).to create_remote_file_if_missing '/tmp/graylog-sidecar-repository_1-2_all.deb'
    end

    it 'installs the sidecar package' do
      expect(chef_run).to install_apt_package('graylog-sidecar')
    end

    it 'installs a system service' do
      expect(chef_run).to run_execute('/usr/bin/graylog-sidecar -service install')
    end

    it 'restarts sidecar service' do
      expect(chef_run).to enable_service 'graylog-sidecar'
    end

    it 'creates a sidecar configuration file' do
      expect(chef_run).to render_file('/etc/graylog/sidecar/sidecar.yml')
    end
  end
end
