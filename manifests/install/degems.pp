# = Class: uabopennebula::install::degems
#
# Manage OpenNebula related Rubygems installation
#  * Calls depackages class with one_install_type before starting with the Rubygems install
#  * Above method may change in later revisions with require function or some other mechanism
#
# == TODO:
# * Set package/gem arrays based on distro type. Also think about better placement/organization
# of these arrays.
#
# == Parameters:
#
# * Parameter: Description (default)
# * $one_oneadmin_home: 'oneadmin' OpenNebula system user's home directory (/home/pavgi)
#
# == Facts:
#
# * None
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

  $one_install_type = "$uabopennebula::params::one_install_type"
) inherits uabopennebula::params {

  # Puppet DSL won't allow appending variables (arrays) in the same scope
  # and it doesn't support string/array manipulation like Ruby/Python.
  # There are possible workarounds in some use cases though.
  $default = ['']
  $sunstone = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'sqlite3-ruby']
  $all = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'sqlite3-ruby', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'xmlparser']

  # 'Include' depackages parameterized class and define require dependency 
  class {"uabopennebula::install::depackages":
    one_install_type => $one_install_type,
  }
  Class['uabopennebula::install::depackages'] -> Class['uabopennebula::install::degems']

  # Install gems based on one_install_type
  case $one_install_type {
    "sunstone": {
      package { $sunstone:
        provider => 'gem',
        ensure => 'installed',
      }
    }

    "all": {
      package { $all:
        provider => 'gem',
        ensure => 'installed' }
    }

    "default": {
      notify{ "No packages installed with $one_install_type option": }
    }
  } # EndCase $one_install_type
} # EndClass uabopennebula::install::degems
