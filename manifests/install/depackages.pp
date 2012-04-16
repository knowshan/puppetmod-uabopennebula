# = Class: uabopennebula::install::depackages
#
# Installs system packages required OpenNebula
# The 'degems' class call/requires this 'depackages' class so that system
# packages are in-place before Rubygems installation.
#
# Requires: depackages -> degems -> installation
#
# == Parameters:
# * Parameter: Description
# * $one_install_type: OpenNebula installation type - all, sunstone
# * $one_install_packages_sunstone: System packages group for 'sunstone'
# * $one_install_packages_all: System packages group for 'all'
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu
#

class uabopennebula::install::depackages (
  $one_install_type = $uabopennebula::params::one_install_type,
  $one_install_packages_sunstone = $uabopennebula::params::one_install_packages_sunstone,
  $one_install_packages_all = $uabopennebula::params::one_install_packages_all
) inherits uabopennebula::params {

  case $one_install_type {
    'sunstone': {
      package{ $one_install_packages_sunstone:
        ensure => 'installed',
      }
    } #EndCase-Sunstone

    'all': {
      package{ $one_install_packages_all:
        ensure => 'installed',
      }
    }

    'default': {
      notify{ "No packages get installed for ${one_install_type} ": }
    }
  } # EndCase
} # EndClass
