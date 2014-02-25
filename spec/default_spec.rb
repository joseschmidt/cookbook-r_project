# encoding: utf-8
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
      node.set['r_project']['qcc']['version'] = '2.718'
      node.set['r_project']['r']['version'] = '0.0.0'
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

    describe "#{Chef::Config['file_cache_path']}/qcc_2.718.tar.gz" do
      it 'does not create remote file' do
        expect(chef_run).to_not create_remote_file(subject)
      end # it
    end # describe

    it 'does not install qcc library' do
      expect(chef_run).to_not run_bash('install_qcc_library')
    end # it
  end # context

  context 'when qcc is not installed' do
    describe "#{Chef::Config['file_cache_path']}/qcc_2.718.tar.gz" do
      it 'creates remote file with expected owner, group' do
        expect(chef_run).to create_remote_file(subject)
          .with(:owner => 'root', :group => 'root')
      end # it
    end # describe

    it 'installs qcc library' do
      expect(chef_run).to run_bash('install_qcc_library')
    end # it
  end # context

  it 'does not uninstall R' do
    expect(chef_run).to_not run_bash('uninstall_qcc_library')
  end # it

end # describe
