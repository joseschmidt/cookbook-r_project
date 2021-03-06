# encoding: utf-8
name              'r_project'
maintainer        'James Hardie Building Products, Inc.'
maintainer_email  'doc.walker@jameshardie.com'
description       'Installs the R language, environment, and related packages'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license           'Apache 2.0'
version           '0.2.0'

#--------------------------------------------------------------------- recipes
recipe            'r_project',
                  'Installs the R language, environment, and related packages'

#------------------------------------------------------- cookbook dependencies
depends           'yum-epel'

#--------------------------------------------------------- supported platforms
# tested
supports          'centos'

# platform_family?('rhel'): not tested, but should work
supports          'amazon'
supports          'oracle'
supports          'redhat'
supports          'scientific'

# platform_family?('debian'): not tested, but may work
supports          'debian'
supports          'ubuntu'
