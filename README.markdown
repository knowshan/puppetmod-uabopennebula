# Puppet module for [OpenNebula](http://opennebula.org/)

## Overview
Puppet module for managing self-contained [OpenNebula](http://opennebula.org/)  
installations. 

## Status
* Still under development
* Worked successfully for manging one_auth file, oned.conf file, vmm_kvm 
  configuration file and gem/package dependencies. 
* Test System: CentOS 6.2, Ruby 1.8.7 and Puppet 2.6.12 

## Examples
* Managing one_auth file for 'oneadmin' user

    class { "uabopennebula::conf::oneauth":
      one_oneadmin_password => "password" 
    }

* Managing oned.conf file with defaults

    class {"uabopennebula::conf::onedconf": }
    

* Managing oned.conf with custom database values

    class {"uabopennebula::conf::onedconf":
      one_db_backend => 'mysql',
      one_db_host => 'localhost',
      one_db_port => '3306',
      one_db_user => 'one',
      one_db_password => 'one',
      one_db_name => 'onedb',
    }

## Module organization 
* uabopennebula::params -> Sets default parameters (ineherited by other classes)
* uabopennebula::install
 * uabopennebula::install::prereq -> Manage installation prerequsites
 * uabopennebula::install::degems -> Manage Rubygems installations (Calls depackages)
 * uabopennebula::install::depackages -> Manage system package installations
* uabopennebula::conf
 * uabopennebula::conf::oneauth -> Manage one_auth configuration file
 * uabopennebula::conf::onedconf -> Manage oned.conf file
 * uabopennebula::conf::vmmkvm -> Manage vmm_exec/vmm_exec_kvm.conf file

## Notes
Some of the module structure (parameterized classes and inheritance) is based on [puppetlabs/puppetlabs-opennebula](https://github.com/puppetlabs/puppetlabs-opennebula) module. However, 
there are some differences:

* Supports self-contained installations
* Attempts to be distro agnostic

Also the module structure is likely to change in later revisions.
