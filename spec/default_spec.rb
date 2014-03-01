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

  describe 'yum-epel' do
    it 'includes described recipe if platform family is rhel' do
      if platform?(:rhel)
        expect(chef_run).to include_recipe(subject)
      else
        expect(chef_run).to_not include_recipe(subject)
      end # if
    end # it
  end # describe

  describe 'R' do
    it 'installs described package' do
      expect(chef_run).to install_package(subject).with_version('0.0.0')
    end # it
  end # describe

  context 'when qcc is installed' do
    before do
      # required for not_if attribute; prevents qcc library download
      stub_command("echo 'library(qcc)' | R --vanilla --quiet")
        .and_return(true)
    end # before

    describe "#{Chef::Config['file_cache_path']}/qcc_2.718.tar.gz" do
      it 'does not create cookbook file' do
        expect(chef_run).to_not create_cookbook_file(subject)
      end # it
    end # describe

    it 'does not install qcc library' do
      expect(chef_run).to_not run_bash('install_qcc_library')
    end # it
  end # context

  context 'when qcc is not installed' do
    describe "#{Chef::Config['file_cache_path']}/qcc_2.718.tar.gz" do
      it 'creates cookbook file with expected owner, group, mode' do
        expect(chef_run).to create_cookbook_file(subject)
          .with(:owner => 'root', :group => 'root', :mode => '0644')
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
