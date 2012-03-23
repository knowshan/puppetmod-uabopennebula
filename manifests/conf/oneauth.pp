# = Class: uabopennebula::conf:oneauth
#
# Manage ONE_AUTH file permissions and contents.
#
# == Parameters:
#
# * Parameter                Description (default)
# * $one_oneadmin_password:  Plain text password string for the oneadmin user account ('password')
# * $one_user:  -  -  -  -   OpenNebula system user account (pavgi)
# * $one_group: -  -  -  -   OpenNebula system group account (pavgi)
# * $one_oneadmin_home: -  - 'oneadmin' OpenNebula system user's home directory (/home/pavgi)
# * $one_oneadmin_authfile:  Path to oneadmin user's authentication file ONE_AUTH ($oneadmin_home/.one_auth)
#
# == Facts:
#
# * None
#
# == Usage
# To set/modify oneadmin user's password in one_auth file write:
# class { "uabopennebula::conf::oneauth":
#   one_oneadmin_password => 'PassWord'
# }
# This may (does) not modify password in OpenNebula database which is done using
# 'oneauth' command. This module manages one_auth file contents and it's permissions.
# See OpenNebula documentation for details on authentication subsystem.
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu

# Parameterized class:
#  * Helps in passing/setting  custom parameter values for the configuration file.
#  * Can't be reused (defined - in puppet terms?) twice - which is good for this stuff.
#  * Inherits uabopennebula::params class:
#    * Advantage: Has access to necessary default values (set at one place)
#    * Disadvantage: Has access to unnecessary default values!
#    * Related discussions:
#     * http://groups.google.com/group/puppet-users/browse_thread/thread/734ec334a9f2ce0
#     * http://groups.google.com/group/puppet-users/browse_thread/thread/551bfb6004ac0f07


class uabopennebula::conf::oneauth (
  # Variables/parameters used in this class with default values from uabopennebula::params
  $one_oneadmin_password = "$uabopennebula::params::one_oneadmin_password",
  $one_oneadmin_home = "$uabopennebula::params::one_oneadmin_home",
  $one_oneadmin_authfile = "$uabopennebula::params::one_oneadmin_authfile"
  ) inherits uabopennebula::params {

  # Manage contents and permissions of $oneadmin_authfile
  file { "$one_oneadmin_authfile":
    content => template('uabopennebula/oneadmin_authfile.erb'),
    owner   => $one_user,
    group   => $one_group,
    mode    => "0600",
  }
}

