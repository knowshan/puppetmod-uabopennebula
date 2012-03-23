# = Class: uabopennebula::params
#
# Provides OpenNebula install/configure specific parameters to other
# uabopennebula classes. Other uabopennebula classes inherit uabopennebula::params
# class to set their defaults.
#
# == Parameters:
#
# * Parameter: Description (default)
# * $one_user: OpenNebula system user account (pavgi)
# * $one_group: OpenNebula system group account (pavgi)
# * $one_oneadmin_home: 'oneadmin' OpenNebula system user's home directory (/home/pavgi)
# * $one_oneadmin_authfile: Path to oneadmin user's authentication file ONE_AUTH ($oneadmin_home/.one_auth)
# * $one_oneadmin_password: Plain text password string for the oneadmin user account ('password')
# * $one_location: OpenNebula install location ($oneadmin_home/tmp-install/cloud/one)
# * $one_install_type: OpenNebula installation type - all, sunstone (default: undef)
# * $one_oned_conf_path: Path to main OpenNebula configuration file oned.conf ($one_location/etc/oned.conf)
# * $one_sunstone_conf_path: Path to Sunstone server configuration file ($one_location/etc/sunstone-server.conf)
#
# == Facts:
#
# * $operatingsystem:   Used to set default system Package provider
#
# == Actions:
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::params {
  # opennebula::controller params
  $one_user = 'pavgi'
  $one_group = 'pavgi'
  $one_uid = '1'
  $one_gid = '1'
  $one_shell = '/bin/bash'
  $one_user_comment = 'Shantanu Pavgi'
  $oneadmin_home = "/home/${one_user}"
  # ONE_AUTH file permissions
  $one_oneadmin_authfile = "${oneadmin_home}/.one_auth"
  $one_oneadmin_password = 'password'
  # Install location
  $one_location = "${oneadmin_home}/tmp-install/cloud/one"
  # Installation type
  $one_install_type = 'default'
  # oned configuration file path
  $one_oned_conf_path = "${one_location}/etc/oned.conf"
  # Sunstone webserver configuration file path
  $one_sunstone_conf_path = "${one_location}/etc/sunstone-server.conf"

  # Set Package provider
  Package {
    provider => $::operatingsystem ? {
      debian    => aptitude,
      ubuntu    => aptitude,
      centos    => yum,
      redhat    => yum,
      default   => yum,
    }
  }
}
