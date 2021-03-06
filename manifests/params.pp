# = Class: uabopennebula::params
#
# Sets default parameter values that are inherited by other classes.
#
# == Parameters:
#
# * Parameter: Description (default)
# Basic parameters - system user account etc.
# * $one_user: OpenNebula system user account (pavgi)
# * $one_group: OpenNebula system group account (pavgi)
# * $one_uid: OpenNebula system user account id (99999)
# * $one_gid: OpenNebula system group account id (99999)
# * $one_shell: OpenNebula system account shell (/bin/bash)
# * $one_user_comment: OpenNebula system user account comment (OpenNebula SysAccount)
# * $one_oneadmin_home: 'oneadmin' OpenNebula system user's home directory (/home/pavgi)
# Installation  parameters
# * $one_location: OpenNebula install location ($oneadmin_home/tmp-install/cloud/one)
# * $one_install_type: OpenNebula installation type - all, sunstone (default: undef)
# * $one_install_forced: Force installation even if one_location is not empty (default: false)
# * $one_install_script: (/tmp/one_install_script)
# * $one_db_backend: Databse backend type - mysql or sqlite (sqlite)
# * $one_install_all_components_degems: Dependency ruby gems for all components installation
# * $one_install_sunstone_component_degems: Dependency ruby gems for sunstone component installation
# * $one_install_all_components_depackages: Dependency system packages for all components installation
# * $one_install_sunstone_component_depackages: Dependency system packages for sunstone component installation
# Configuration parameters
# * $one_oneadmin_authfile: Path to oneadmin user's authentication file ONE_AUTH ($oneadmin_home/.one_auth)
# * $one_oneadmin_password: Plain text password string for the oneadmin user account ('password')
# * $one_oned_conf_path: Path to main OpenNebula configuration file oned.conf ($one_location/etc/oned.conf)
# * $one_sunstone_conf_path: Path to Sunstone server configuration file ($one_location/etc/sunstone-server.conf)
# * $one_db_backend: Databse backend type - mysql or sqlite (sqlite)
#
# == Facts:
#
# * $operatingsystem:   Used to set default system Package provider
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::params {
  # opennebula::controller params
  $one_user = 'pavgi'
  $one_group = 'pavgi'
  $one_uid = '99999'
  $one_gid = '99999'
  $one_shell = '/bin/bash'
  $one_user_comment = 'Shantanu Pavgi'
  $oneadmin_home = "/home/${one_user}"
  # ONE_AUTH file permissions
  $one_oneadmin_authfile = "${oneadmin_home}/.one_auth"
  $one_oneadmin_password = 'password'
  # Install location
  $one_version = '3.2.1'
  $one_install_script = "/tmp/one_install_script"
  $one_location = "${oneadmin_home}/tmp-install/cloud/one"
  # Installation type
  $one_install_type = 'default'
  $one_install_forced = 'false'
  # oned configuration file path
  $one_oned_conf_path = "${one_location}/etc/oned.conf"
  # Sunstone webserver configuration file path
  $one_sunstone_conf_path = "${one_location}/etc/sunstone-server.conf"
  # database backend
  $one_db_backend = 'sqlite'

  # Allowed values for various parameters and facts
  $one_db_backend_allowed = ['^mysql$','^sqlite$']
  $one_os_distros_allowed = ['^CentOS$','^Ubuntu$']

  validate_re($operatingsystem,$one_os_distros_allowed)

  # System Packages groups according to installation type and OS distro
  $one_install_sunstone_component_depackages = $operatingsystem ? {
    CentOS => ['gcc', 'gcc-c++', 'libcurl-devel', 'ruby', 'ruby-libs', 'ruby-devel', 'ruby-irb', 'ruby-docs', 'ruby-rdoc', 'ruby-ri', 'rubygems', 'cmake', 'sqlite-devel', 'scons'],
    Ubuntu => ['build-essential','ruby', 'libcurl3', 'libruby','ruby-dev','irb','rdoc','ri','rubygems','rubygems-doc','libsqlite3-dev','scons'],
  }

  $one_install_all_components_depackages = $operatingsystem ? {
    CentOS => ['bluez-libs-devel', 'bzip2-devel', 'db4-devel', 'gcc', 'gcc-c++', 'libcurl-devel', 'gdbm-devel', 'openssl-devel', 'ncurses-devel', 'readline-devel', 'sqlite-devel', 'tkinter', 'tk-devel', 'zlib-devel', 'xmlrpc-c-devel', 'libxslt-devel', 'expat-devel', 'libgcrypt-devel', 'libgpg-error-devel', 'ruby', 'ruby-libs', 'ruby-devel', 'ruby-irb', 'ruby-docs', 'ruby-rdoc', 'ruby-ri', 'rubygems', 'cmake', 'scons', 'mysql-server', 'mysql-devel'],
    Ubuntu => ['libbluetooth-dev', 'bzip2', 'lbzip2', 'libdb4.7', 'build-essential', 'libcurl3', 'libcurl3-gnutls', 'libcurl4-openssl-dev', 'libgdbm-dev', 'libssl-dev', 'libncurses5-dev', 'libreadline-dev', 'libsqlite3-dev', 'python-tk', 'idle', 'python-pmw', 'python-imaging', 'tk-dev', 'zlib1g-dev', 'libxmlrpc-core-c3-dev', 'libxmlrpc-c3-dev', 'libxslt1-dev', 'libexpat1-dev', 'libgcrypt11-dev', 'libgpg-error-dev', 'ruby', 'libruby', 'ruby-dev', 'irb', 'rdoc', 'ri', 'rubygems', 'rubygems-doc', 'cmake', 'scons', 'mysql-client', 'mysql-server', 'libmysqlclient-dev'],
  }

  # Gem groups according to Ruby version
  if $rubyversion >= '1.8.7'{
    if $rubyversion == '1.8.7'{ # requires xmlparser and nokogiri shouldn't be installed
      $one_install_sunstone_component_degems = ['json', 'rack', 'sinatra', 'thin', 'sequel']
      $one_install_all_components_degems = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'xmlparser']
      $one_install_gem_sqlite = 'sqlite3'
      $one_install_gem_sqlite_version = 'installed'
    } else { # gems for Ruby > 1.8.7 - requires nokogiri and xmlparser shouldn't be installed
      $one_install_sunstone_component_degems = ['json', 'rack', 'sinatra', 'thin', 'sequel']
      $one_install_all_components_degems = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'nokogiri']
      $one_install_gem_sqlite = 'sqlite3'
      $one_install_gem_sqlite_version = 'installed'
    }
  } else { # gems for ruby < 1.8.7 - both xmlparser and nokogiri installed, also installed sqlite3-ruby v1.2.0 instead of sqlite3
      $one_install_sunstone_component_degems = ['json', 'rack', 'sinatra', 'thin', 'sequel']
      $one_install_all_components_degems = ['json', 'rack', 'sinatra', 'thin', 'sequel', 'amazon-ec2', 'uuidtools', 'curb', 'mysql', 'data_mapper', 'dm-sqlite-adapter', 'dm-mysql-adapter', 'net-ldap', 'nokogiri', 'xmlparser']
      $one_install_gem_sqlite = 'sqlite3-ruby'
      $one_install_gem_sqlite_version = '1.2.0'
  }
}
