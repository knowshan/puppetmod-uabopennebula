# = Class: uabopennebula::install::installation
#
# Installs OpenNebula from source
# Creates and executes OpenNebula installation script based on given parameters.
# This OpenNebula installation script is a wrapper around the 'install.sh'
# script that comes with the OpenNebula source. It performs a self-contained
# directory install in the specified directory (one_location). It will remove
# all existing files in the one_location before performing the installation.
#
# The installation cab be either be 'all' core components install or only
# 'sunstone' add-on install. The 'all' type install doesn't install 'sunstone'
# component (not implemented in OpenNebula's install.sh script). And the
# 'sunstone' type install doesn't install any of the core components.
#
# This 'installation' calls the 'degems' class for Rubygems installation before
# starting with the OpenNebula installation. The degems class in turn calls
# depackages class for system packages installation.
#
# == Parameters:
#
# * Parameter: Description
# * $one_install_script: OpenNebula installation script location
# * $one_install_type: OpenNebula installation type - all, sunstone
# * $one_user: OpenNebula system user account
# * $one_group: OpenNebula system group account
# * $one_location: OpenNebula install location
# * $one_db_backend: Database backend type - sqlite or mysql
#
# TODO/Issues:
# A Puppet class can't be defined or evaluated twice for the same node type.
# And hence right now this 'class' implementation can't support both 'all' and
# 'sunstone' type install on the same node. I am planning to add Puppet define
# constructs to address this issue.
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::install::installation (
  $one_version = $uabopennebula::params::one_version,
  $one_install_script = $uabopennebula::params::one_install_script,
  $one_install_type = $uabopennebula::params::one_install_type,
  $one_db_backend = $uabopennebula::params::one_db_backend,
  $one_user = $uabopennebula::params::one_user,
  $one_group = $uabopennebula::params::one_group,
  $one_location = $uabopennebula::params::one_location,
  $one_install_gems_sunstone = $uabopennebula::params::one_install_gems_sunstone,
  $one_install_gems_all = $uabopennebula::params::one_install_gems_all,
  $one_install_gem_sqlite = $uabopennebula::params::one_install_gem_sqlite,
  $one_install_gem_sqlite_version = $uabopennebula::params::one_install_gem_sqlite_version,
  $one_install_packages_sunstone = $uabopennebula::params::one_install_packages_sunstone,
  $one_install_packages_all = $uabopennebula::params::one_install_packages_all
) inherits uabopennebula::params {

  # Rubygems should be in place before OpenNebula installation
  # Call/Require/Evaluate degems class before evaluating installation class
  class{"uabopennebula::install::degems":
    one_install_type               => $one_install_type,
    one_install_gems_sunstone      => $one_install_gems_sunstone,
    one_install_gems_all           => $one_install_gems_all,
    one_install_gem_sqlite         => $one_install_gem_sqlite,
    one_install_gem_sqlite_version => $one_install_gem_sqlite_version,
    one_install_packages_sunstone  => $one_install_packages_sunstone,
    one_install_packages_all       => $one_install_packages_all,
  }
  Class['uabopennebula::install::degems'] -> Class['uabopennebula::install::installation']

  # Create install script based on one_user, one_location etc.
  file{$one_install_script:
    mode    => '0700',
    content => template('uabopennebula/one_install_script.erb'),
  }

  # Install script purges all files in one_location before installing OpenNebula files
  exec{$one_install_script:
    require => File[$one_install_script],
  }
}
