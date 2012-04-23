# = Class: uabopennebula::install::all_components_degems
#
# Installs OpenNebula related Rubygems
# This class installs Rubygems required for all components of the OpenNebula
# accodrding to Ruby version. It calls the 'depackages' class to install
# necessary system packages before starting with the Rubygems installation.
#
# The 'all_components' class calls/requires this 'degems' class before starting
# the installation process.
#
# Requires: all_components_depackages -> all_components_degems -> all_components
#
# == Parameters:
#
# * Parameter: Description
# * $one_install_all_components_degems: Dependency ruby gems for all components install
# * $one_install_all_components_depackages: Dependency system packages for all components install
# * $one_install_gem_sqlite: Rubygem for sqlite database
# * $one_install_gem_sqlite_version: Rubygem version for sqlite database
#
# == Usage
# Install Rubygems and system packages related to 'sunstone' server:
#   class { 'uabopennebula::install::all_components_degems': }
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu
#

class uabopennebula::install::all_components_degems (
  $one_install_all_components_degems = $uabopennebula::params::one_install_all_components_degems,
  $one_install_gem_sqlite = $uabopennebula::params::one_install_gem_sqlite,
  $one_install_gem_sqlite_version = $uabopennebula::params::one_install_gem_sqlite_version,
  $one_install_all_components_depackages = $uabopennebula::params::one_install_all_components_depackages
) inherits uabopennebula::params {

  # Install system packages before installing Rubygems
  # Call/Require/Evaluate depackages class before evaluating degems class
  class {'uabopennebula::install::all_components_depackages':
    one_install_all_components_depackages => $one_install_all_components_depackages,
  }
  Class['uabopennebula::install::all_components_depackages'] -> Class['uabopennebula::install::all_components_degems']

  # Install gems based on one_install_type
  package { $one_install_all_components_degems:
    provider => 'gem',
    ensure   => 'installed',
  }
  # sqlite
  package { $one_install_gem_sqlite:
    provider => 'gem',
    ensure   => $one_install_gem_sqlite_version,
  }

} # EndClass uabopennebula::install::degems
