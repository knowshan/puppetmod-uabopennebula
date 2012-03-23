# = Class: uabopennebula::install::depackages
#
# Manage OpenNebula related system packages installation
#  * Right now this class is called by uabopennebula::install::degems class and
#  hence it shouldn't be called directly. May change in later revisions.
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
# == Author(s):
# * Shantanu Pavgi, pavgi@uab.edu
#

class uabopennebula::install::depackages (
  $one_install_type = "$uabopennebula::params::one_install_type"
) inherits uabopennebula::params {

  # Install OS specific packages
  # Assumption/Requirement: site.pp has already cnfigured
  # OS specific Package providers
  $default = ['']
  $sunstone = ['gcc', 'gcc-c++', 'ruby', 'ruby-libs', 'ruby-devel', 'ruby-irb', 'ruby-docs', 'ruby-rdoc', 'ruby-ri', 'rubygems', 'cmake', 'scons']
  $all = ['bluez-libs-devel', 'bzip2-devel', 'db4-devel', 'g++', 'gcc', 'gcc-c++', 'gdbm-devel', 'openssl-devel', 'ncurses-devel', 'readline-devel', 'sqlite-devel', 'tkinter', 'tk-devel', 'zlib-devel', 'xmlrpc-c-devel', 'libxslt-devel', 'libgcrypt-devel', 'libgpg-error-devel', 'ruby', 'ruby-libs', 'ruby-devel', 'ruby-irb', 'ruby-docs', 'ruby-rdoc', 'ruby-ri', 'rubygems', 'cmake', 'scons']

  case $one_install_type {
    "sunstone": {
      package{ $sunstone:
        ensure => 'installed',
      }
    } #EndCase-Sunstone

    "all": {
      package{ $all:
        ensure => 'installed',
      }
    }

    "default": {
      notify{ "No packages get installed for ${one_install_type} ": }
    }
  } # EndCase
} # EndClass
