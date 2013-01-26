require 'chefspec'
require 'fauxhai'

describe 'r_project::default' do
  before do
    Fauxhai.mock do |node|
      node['r_project'] = {
        'qcc' => {
          'version' => '2.718'
        },
        'r' => {
          'version' => '0.0.0'
        }
      }
    end
  end
  
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'r_project::default' }
  
  it 'should install R v0.0.0' do
    chef_run.should install_package_at_version('R', '0.0.0')
  end
  
  it 'should create remote_file owned by root:root' do
    qcc_tar_gz = "qcc_2.718.tar.gz"
    qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"
    chef_run.should create_remote_file(qcc_filename)
    chef_run.remote_file(qcc_filename).should be_owned_by 'root', 'root'
  end
  
  it 'should install qcc library' do
    qcc_tar_gz = "qcc_0.0.0.tar.gz"
    qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"
    code = "sudo -E sh -c 'R CMD INSTALL #{qcc_filename}'"
    # chef_run.should execute_command code
    pending 'TODO: figure out how to test not_if {}'
  end
  
  it 'should not uninstall R' do
    chef_run.should_not execute_command "sudo -E sh -c 'R CMD REMOVE qcc'"
  end
  
end
