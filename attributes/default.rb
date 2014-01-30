# coding: utf-8
#
# Cookbook Name:: r_project
# Attributes:: default
#

if platform_family?('rhel') && node['platform_version'][0] == '6'
  default['r_project']['r']['version']    = '3.0.2-1.el6'
else
  default['r_project']['r']['version']    = '2.15.2-1.el5'
end # if

default['r_project']['qcc']['version']  = '2.2'
default['r_project']['qcc']['url']      = 'http://cran.r-project.org/src/' +
  "contrib/qcc_#{node['r_project']['qcc']['version']}.tar.gz"
default['r_project']['qcc']['checksum'] = '9a0c991444a08c674eadee83e1cabd' +
  '56d7433b0d5da7c7561f1b99b3b8350582' # Mac OS: $ shasum -a 256 <file>
