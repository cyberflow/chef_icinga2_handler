name             'chef_icinga2_handler'
maintainer       'Servers.com'
maintainer_email 'dr@servers.com'
license          'Apache-2.0'
description      'Installs/Configures chef_icinga2_handler'
long_description 'Installs/Configures chef_icinga2_handler'
version          '0.0.1'

chef_version '>= 12.5' if respond_to?(:chef_version)

source_url 'https://git.mgm.servers.com/cookbooks/chef_icinga2_handler' if respond_to?(:source_url)
issues_url 'https://git.mgm.servers.com/cookbooks/chef_icinga2_handler/issues' if respond_to?(:issues_url)

supports 'ubuntu', '>= 16.04'

depends 'chef_handler'
