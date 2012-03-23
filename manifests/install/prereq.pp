# = Class: uabopennebula::install::prereq
#
# Manage OpenNebula installation prerequisites.
#  * Creates one_user account - system user account which will run OpenNebula process
#
# == Parameters:
#
# * Parameter: Description (default)
# * $one_user: OpenNebula system user account (pavgi)
# * $one_group: OpenNebula system group account (pavgi)
# * $one_oneadmin_home: 'oneadmin' OpenNebula system user's home directory (/home/pavgi)
#
# == Facts:
#
# * None
#
# == Usage
# Call this class from manifest as:
#   class { "uabopennebula::install::prereq": }
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu
#

class uabopennebula::install::prereq (
  $one_user = "$uabopennebula::params::one_user",
  $one_group = "$uabopennebula::params::one_group",
  $one_uid = "$uabopennebula::params::one_uid",
  $one_gid = "$uabopennebula::params::one_gid",
  $one_shell = "$uabopennebula::params::one_shell",
  $one_comment = "$uabopennebula::params::one_user_comment",
  $oneadmin_home = "$uabopennebula::params::oneadmin_home"
) inherits uabopennebula::params {
  user { $one_user:
    ensure => present,
    uid => $one_uid,
    gid => $one_gid,
    groups  => $one_group,
    comment => $one_comment,
    shell   => $one_shell,
  }
}
