# = Class: uabopennebula::run::one_init
#
# Manage OpenNebula one daemon service
# * Manage init script
# * Manage one daemon
#
# == Parameters:
#
# * Parameter: Description
# * $one_user: OpenNebula system user account
# * $one_group: OpenNebula system group account
# * $one_location: OpenNebula install location
# * $one_oneadmin_authfile:  Path to oneadmin user's authentication file ONE_AUTH ($oneadmin_home/.one_auth)
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::run::one_init (
  $one_user = $uabopennebula::params::one_user,
  $one_group = $uabopennebula::params::one_group,
  $one_oneadmin_auth_file = $uabopennebula::params::one_oneadmin_authfile,
  $one_location = $uabopennebula::params::one_location
) inherits uabopennebula::params {

  file{'/etc/init.d/oned':
    mode    => '0755',
    content => template('uabopennebula/one_initd.erb'),
  }

  service{'oned':
    ensure  => 'running',
    enable  => 'true',
    require => File['/etc/init.d/oned'],
  }
}
