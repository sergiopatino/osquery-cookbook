require 'spec_helper'

context 'when os x' do
  describe 'osquery::default' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.automatic['platform'] = 'mac_os_x'
        node.set['osquery']['packs'] = ['hardware-monitoring']
      end.converge(described_recipe)
    end

    it 'converges without error' do
      expect { chef_run }.not_to raise_error
    end

    it 'includes mac os x installation recipe' do
      expect(chef_run).to include_recipe('osquery::mac_os_x')
    end
  end
end