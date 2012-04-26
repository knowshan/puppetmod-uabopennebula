# = Class: uabopennebula::install::all_components
#
# Installs OpenNebula from source
# Creates and executes OpenNebula installation script based on given parameters.
# This OpenNebula installation script is a wrapper around the 'install.sh'
# script that comes with the OpenNebula source. It performs a self-contained
# directory install in the specified directory (one_location). It will remove
# all existing files in the one_location before performing the installation.
#
# This 'installation' calls the 'degems' class for Rubygems installation before
# starting with the OpenNebula installation. The degems class in turn calls
# depackages class for system packages installation.
#
# == Parameters:
#
# * Parameter: Description
# * $one_install_script: OpenNebula installation script location
# * $one_user: OpenNebula system user account
# * $one_group: OpenNebula system group account
# * $one_location: OpenNebula install location
# * $one_db_backend: Database backend type - sqlite or mysql
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::install::all_components (
  $one_version = $uabopennebula::params::one_version,
  $one_install_script = $uabopennebula::params::one_install_script,
  $one_db_backend = $uabopennebula::params::one_db_backend,
  $one_user = $uabopennebula::params::one_user,
  $one_group = $uabopennebula::params::one_group,
  $one_location = $uabopennebula::params::one_location,
  $one_install_forced = $uabopennebula::params::one_install_forced,
  $one_install_all_components_degems = $uabopennebula::params::one_install_all_components_degems,
  $one_install_gem_sqlite = $uabopennebula::params::one_install_gem_sqlite,
  $one_install_gem_sqlite_version = $uabopennebula::params::one_install_gem_sqlite_version,
  $one_install_all_components_depackages = $uabopennebula::params::one_install_all_components_depackages
) inherits uabopennebula::params {

  # Rubygems should be in place before OpenNebula installation
  # Call/Require/Evaluate degems class before evaluating installation class
  class{'uabopennebula::install::all_components_degems':
    one_install_all_components_degems     => $one_install_all_components_degems,
    one_install_gem_sqlite                => $one_install_gem_sqlite,
    one_install_gem_sqlite_version        => $one_install_gem_sqlite_version,
    one_install_all_components_depackages => $one_install_all_components_depackages,
  }
  Class['uabopennebula::install::all_components_degems'] -> Class['uabopennebula::install::all_components']

  # Create install script based on one_user, one_location etc.
  file{$one_install_script:
    mode    => '0700',
    content => template('uabopennebula/one_install_script.erb'),
  }

# Don't run install script if one_install_forced is false && one_location is non-empty
  exec{$one_install_script:
    require => File[$one_install_script],
    provider => 'shell',
    onlyif => "[[ ( -z \"$(/bin/ls -A $one_location)\" ) || ('$one_install_forced' == 'true') ]]",
  }
}
