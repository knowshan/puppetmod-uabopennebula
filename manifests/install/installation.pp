# = Class: uabopennebula::install::installation
#
# Creates an installation script based on given parameters and then executes the script.
# Before execution it calls uabopennebula::install::degems class to install necessary
# Rubygems.
#
# == Parameters:
#
# * Parameter: Description (default)
# * $one_install_script: OpenNebula installation script location (default: /tmp/one_install_script)
# * $one_install_type: OpenNebula installation type - all, sunstone (default: default)
# * $one_user: OpenNebula system user account (pavgi)
# * $one_group: OpenNebula system group account (pavgi)
# * $one_location: OpenNebula install location ($oneadmin_home/tmp-install/cloud/one)
# * $one_db_backend: Database backend type - sqlite or mysql (Default: sqlite)
#
# == Supported Installation Types/Options:
# This class creates and executes a wrapper script (around install.sh shipped with OpenNebula source)
# for OpenNebula installation from source.
# It will install OpenNebula in a self-contained directory. The installation type can either be
# an 'all' core components install or only 'sunstone' add-on install. The 'all' type install doesn't
# install 'sunstone' component (not implemented in OpenNebula's install.sh script). The 'sunstone' type
# doesn't install any of the core components as well.
# This class calls/requires Rubygems installation class (degems - dependency gems) before running the
# installation script. The 'degems' class in turn ensures that required system packages are installed
# for OpenNebula source and Rubygems.
#
# TODO/Issues: A Puppet class can't be defined or evaluated twice for the same node type. And hence right now
# this implementation can't support both 'all' and 'sunstone' install for the same node. I am planning to add
# Puppet define constructs soon to address this issue.
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::install::installation (
  $one_install_script = "$uabopennebula::params::one_install_script",
  $one_install_type = "$uabopennebula::params::one_install_type",
  $one_db_backend = "$uabopennebula::params::one_db_backend",
  $one_user = "$uabopennebula::params::one_user",
  $one_group = "$uabopennebula::params::one_group",
  $one_location = "$uabopennebula::params::one_location"
) inherits uabopennebula::params {

  class{"uabopennebula::install::degems":
    one_install_type => $one_install_type,
  }

  Class['uabopennebula::install::degems'] -> Class['uabopennebula::install::installation']

  file{$one_install_script:
    mode    => '0700',
    content => template('uabopennebula/one_install_script.erb'),
  }

  exec{$one_install_script:
    unless  => "/usr/bin/test -d ${one_location}",
    require => File[$one_install_script],
  }
}
