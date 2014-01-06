require 'spec_helper'

describe 'r_project::default' do
  before do
    # required for not_if attribute; causes qcc library to be downloaded
    stub_command("echo 'library(qcc)' | R --vanilla --quiet")
      .and_return(false)
  end # before

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      # override cookbook attributes
      node.set['r_project'] = {
        'qcc' => {
          'version' => '2.718'
        },
        'r' => {
          'version' => '0.0.0'
        }
      }
    end.converge(described_recipe)
  end # let

  it 'installs R v0.0.0' do
    expect(chef_run).to install_package('R').with(:version => '0.0.0')
  end # it

  context 'when qcc is installed' do
    before do
      # required for not_if attribute; prevents qcc library download
      stub_command("echo 'library(qcc)' | R --vanilla --quiet")
        .and_return(true)
    end # before

    it 'does not create remote_file' do
      qcc_tar_gz = "qcc_2.718.tar.gz"
      qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"
      expect(chef_run).to_not create_remote_file(qcc_filename)
    end # it

    it 'does not install qcc library' do
      expect(chef_run).to_not run_bash('install_qcc_library')
    end # it
  end # context

  context 'when qcc is not installed' do
    it 'creates remote_file owned by root:root' do
      qcc_tar_gz = "qcc_2.718.tar.gz"
      qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"
      expect(chef_run).to create_remote_file(qcc_filename)
        .with(:owner => 'root', :group => 'root')
    end # it

    it 'installs qcc library' do
      expect(chef_run).to run_bash('install_qcc_library')
    end # it
  end # context

  it 'does not uninstall R' do
    expect(chef_run).to_not run_bash('uninstall_qcc_library')
  end # it

end # describe
