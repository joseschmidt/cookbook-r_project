# encoding: utf-8
#
# Cookbook Name:: r_project
# Recipe:: default
#
# Copyright 2012-2013, James Hardie Building Products, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'yum::epel' if platform_family?('rhel')

#-------------------------------------------------------- install dependencies
Chef::Config['yum_timeout'] = 1800
# install R via epel
package 'R' do
  version node['r_project']['r']['version']
end # package

#------------------------------------------------------ download & install qcc
# set qcc filename
qcc_tar_gz = "qcc_#{node['r_project']['qcc']['version']}.tar.gz"
qcc_filename = "#{Chef::Config['file_cache_path']}/#{qcc_tar_gz}"

# download qcc unless library is already installed
qcc_installed = "echo 'library(qcc)' | R --vanilla --quiet"
remote_file qcc_filename do
  source   node['r_project']['qcc']['url']
  checksum node['r_project']['qcc']['checksum']
  owner    'root'
  group    'root'
  mode     '0644'
  notifies :run, 'bash[install_qcc_library]', :immediately
  not_if qcc_installed
end # remote_file

# install qcc library
bash 'install_qcc_library' do
  cwd ::File.dirname(qcc_filename)
  code "sudo -E sh -c 'R CMD INSTALL #{qcc_filename}'"
  not_if qcc_installed
end # bash

# uninstall qcc library (not currently used)
bash 'uninstall_qcc_library' do
  code "sudo -E sh -c 'R CMD REMOVE qcc'"
  action :nothing
end # bash
