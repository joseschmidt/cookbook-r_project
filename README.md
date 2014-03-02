r_project Cookbook
==================
[![Build Status](https://travis-ci.org/jhx/cookbook-r_project.png?branch=master)](https://travis-ci.org/jhx/cookbook-r_project)
[![Dependency Status](https://gemnasium.com/jhx/cookbook-r_project.png)](https://gemnasium.com/jhx/cookbook-r_project)

Installs the R language, environment, and related packages.


Requirements
------------
### Cookbooks
The following cookbook is a direct dependency because it's used for common "default" functionality.

- [`yum-epel`](https://github.com/opscode-cookbooks/yum-epel)

### Platforms
The following platforms are supported and tested under Test Kitchen:

- CentosOS 5.10, 6.5

Other RHEL family distributions are assumed to work. See [TESTING](TESTING.md) for information about running tests in Opscode's Test Kitchen.


Attributes
----------
Refer to [`attributes/default.rb`](attributes/default.rb) for default values.

- `node['r_project']['r']['version']` - version of R to be installed
- `node['r_project']['qcc']['version']` - version of qcc library to be installed
- `node['r_project']['qcc']['url']` - URL from which to retrieve qcc library
- `node['r_project']['qcc']['checksum']` - checksum of qcc library


Recipes
-------
This cookbook provides one main recipe for configuring the network.

- `default.rb` - *Use this recipe* to install the R language, environment, and related packages.

### default
Installs the R language, environment, and related packages.


Usage
-----
On client nodes, use the default recipe:

````javascript
{ "run_list": ["recipe[r_project]"] }
````

The following are the key items achieved by this cookbook:

- installs the specified version of the `R` language and environment
- installs the specified version of the `qcc` library


License & Authors
-----------------
- Author:: Doc Walker (<doc.walker@jameshardie.com>)

````text
Copyright 2013-2014, James Hardie Building Products, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
````
