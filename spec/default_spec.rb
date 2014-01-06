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

  it 'should install R v0.0.0' do
    expect(chef_run).to install_package('R').with(:version => '0.0.0')
  end # it

  it 'should create remote_file owned by root:root' do
    qcc_tar_gz = "qcc_2.718.tar.gz"
    qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"
    expect(chef_run).to create_remote_file(qcc_filename)
      .with(:owner => 'root', :group => 'root')
  end # it

  it 'should install qcc library' do
    qcc_tar_gz = "qcc_0.0.0.tar.gz"
    qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"
    code = "sudo -E sh -c 'R CMD INSTALL #{qcc_filename}'"
    # chef_run.should execute_command code
    pending 'TODO: figure out how to test not_if {}'
  end # it

  it 'should not uninstall R' do
    expect(chef_run).to_not run_execute("sudo -E sh -c 'R CMD REMOVE qcc'")
  end # it

end # describe
