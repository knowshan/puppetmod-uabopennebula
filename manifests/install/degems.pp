# = Class: uabopennebula::install::degems
#
# Installs OpenNebula related Rubygems
# This class installs Rubygems according to OpenNebula installation type and
# Ruby version. It calls the 'depackages' class to install necessary system
# system packages before starting with the Rubygems installation.
#
# The 'installation' class calls/requires this 'degems' class before starting
# the installation process.
#
# Requires: depackages -> degems -> installation
#
# == Parameters:
#
# * Parameter: Description
# * $one_install_type: OpenNebula installation type - all, sunstone
# * $one_install_gems_sunstone: Rubygems group for 'sunstone' type install
# * $one_install_gems_all: Rubygems group for 'all' type install
# * $one_install_gem_sqlite: Rubygem for sqlite database
# * $one_install_gem_sqlite_version: Rubygem version for sqlite database
# * $one_install_packages_sunstone: System packages group for 'sunstone'
# * $one_install_packages_all: System packages group for 'all'
#
# == Usage
# Install Rubygems and system packages related to 'sunstone' server:
#   class { "uabopennebula::install::degems":
#     one_install_type => 'sunstone'
#    }
#
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu
#

class uabopennebula::install::degems (
  $one_install_type = $uabopennebula::params::one_install_type,
  $one_install_gems_sunstone = $uabopennebula::params::one_install_gems_sunstone,
  $one_install_gems_all = $uabopennebula::params::one_install_gems_all,
  $one_install_gem_sqlite = $uabopennebula::params::one_install_gem_sqlite,
  $one_install_gem_sqlite_version = $uabopennebula::params::one_install_gem_sqlite_version,
  $one_install_packages_sunstone = $uabopennebula::params::one_install_packages_sunstone,
  $one_install_packages_all = $uabopennebula::params::one_install_packages_all
) inherits uabopennebula::params {

  # Install system packages before installing Rubygems
  # Call/Require/Evaluate depackages class before evaluating degems class
  class {"uabopennebula::install::depackages":
    one_install_type => $one_install_type,
    one_install_packages_sunstone => $one_install_packages_sunstone,
    one_install_packages_all => $one_install_packages_all,
  }
  Class['uabopennebula::install::depackages'] -> Class['uabopennebula::install::degems']

  # Install gems based on one_install_type
  case $one_install_type {
    'sunstone': {
      package { $one_install_gems_sunstone:
        provider => 'gem',
        ensure   => 'installed',
      }
      # sqlite
      package { $one_install_gem_sqlite:
        provider => 'gem',
        ensure   => $one_install_gem__sqlite_version,
      }
    }

    'all': {
      package { $one_install_gems_all:
        provider => 'gem',
        ensure   => 'installed'
      }
      # sqlite
      package { $one_install_gem_sqlite:
        provider => 'gem',
        ensure   => $one_install_gem_sqlite_version,
      }
    }

    'default': {
      notify{ "No gems installed with $one_install_type option": }
    }
  } # EndCase $one_install_type
} # EndClass uabopennebula::install::degems
