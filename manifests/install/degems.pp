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
  if $rubyversion >= '1.8.7'{
    if $rubyversion == '1.8.7'{ # requires xmlparser and nokogiri shouldn't be installed
      $sunstone = ['json', 'rack', 'sinatra', 'thin', 'sequel']
      $all = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'xmlparser']
      $sqlite_gem = 'sqlite3'
      $sqlite_gem_version = 'installed'
    } else { # gems for Ruby > 1.8.7 - requires nokogiri and xmlparser shouldn't be installed
      $sunstone = ['json', 'rack', 'sinatra', 'thin', 'sequel']
      $all = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'nokogiri']
      $sqlite_gem = 'sqlite3'
      $sqlite_gem_version = 'installed'
    }
  } else { # gems for ruby < 1.8.7 - both xmlparser and nokogiri installed, also installed sqlite3-ruby v1.2.0 instead of sqlite3
      $sunstone = ['json', 'rack', 'sinatra', 'thin', 'sequel']
      $all = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'sqlite3-ruby', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'nokogiri', 'xmlparser']
      $sqlite_gem = 'sqlite3-ruby'
      $sqlite_gem_version = '1.2.0'
  }

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
        ensure   => 'installed',
      }
      # sqlite
      package { $sqlite_gem:
        provider => 'gem',
        ensure   => $sqlite_gem_version,
      }
      notify{ "Gems $sunstone ": }
    }

    "all": {
      package { $all:
        provider => 'gem',
        ensure   => 'installed'
      }
      # sqlite
      package { $sqlite_gem:
        provider => 'gem',
        ensure   => $sqlite_gem_version,
      }
      notify{ "Gems $all ": }
    }

    "default": {
      notify{ "No packages installed with $one_install_type option": }
    }
  } # EndCase $one_install_type
} # EndClass uabopennebula::install::degems
