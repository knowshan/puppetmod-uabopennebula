# = Class: uabopennebula::install::all_components_depackages
#
# Installs system packages required OpenNebula
# The 'degems' class call/requires this 'depackages' class so that system
# packages are in-place before Rubygems installation.
#
# Requires: all_components_depackages -> all_components_degems -> all_components
#
# == Parameters:
# * Parameter: Description
# * $one_install_all_components_depackages: System packages group for 'all'
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu
#

class uabopennebula::install::all_components_depackages (
  $one_install_all_components_depackages = $uabopennebula::params::one_install_all_components_depackages
) inherits uabopennebula::params {

  package{ $one_install_all_components_depackages:
    ensure => 'installed',
  }
} # EndClass
