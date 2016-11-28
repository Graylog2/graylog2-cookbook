require 'spec_helper'

describe 'graylog2::collector_sidecar' do
  context 'when the cookbook installs collector-sidecar on a Ubuntu system' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        file_cache_path: '/tmp'
      ) do |node|
        node.normal['graylog2']['sidecar']['version'] = '0.0.8'
        node.normal['graylog2']['sidecar']['build'] = 1
      end.converge('graylog2::collector_sidecar')
    end

    it 'downloads the sidecar package' do
      expect(chef_run).to create_remote_file_if_missing '/tmp/collector-sidecar_0.0.8-1_amd64.deb'
    end

    it 'installs the sidecar package' do
      expect(chef_run).to install_package 'graylog-collector-sidecar'
    end

    it 'installs a system service' do
      expect(chef_run).to run_execute('/usr/bin/graylog-collector-sidecar -service install')
    end

    it 'restarts sidecar service' do
      expect(chef_run).to enable_service 'collector-sidecar'
    end

    it 'creates a sidecar configuration file' do
      expect(chef_run).to render_file('/etc/graylog/collector-sidecar/collector_sidecar.yml')
    end
  end
end
