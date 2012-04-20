# Puppet module for [OpenNebula](http://opennebula.org/)

## Overview
Puppet module for managing self-contained [OpenNebula](http://opennebula.org/)  
installations. 

## Status
* Still under development
* Test System: CentOS 6.2, Ruby 1.8.7 and Puppet 2.6.12 

## Examples
Installing OpenNebula from source with sqlite database backend:

    class {"uabopennebula::install::installation"
      one_version        => '3.4',
      one_install_type   => 'all',
      one_location       => '/srv/cloud/one',
      one_db_backend     => 'sqlite',
    }

Managing one_auth file for 'oneadmin' user

    class { "uabopennebula::conf::oneauth":
      one_oneadmin_password => "password",
    }

Managing oned.conf file with defaults

    class {"uabopennebula::conf::onedconf": }
    

Managing oned.conf with custom database values

    class {"uabopennebula::conf::onedconf":
      one_db_backend  => 'mysql',
      one_db_host     => 'localhost',
      one_db_port     => '3306',
      one_db_user     => 'one',
      one_db_password => 'one',
      one_db_name     => 'onedb',
    }

## Module organization 
* uabopennebula::params - Sets default parameters (ineherited by other classes)
* uabopennebula::install
 * uabopennebula::install::prereq - Manage installation prerequsites
 * uabopennebula::install::degems - Manage Rubygems installations
 * uabopennebula::install::depackages - Manage system package installations
 * uabopennebula::install::installation - Manage OpenNebula installation from source
* uabopennebula::conf
 * uabopennebula::conf::oneauth - Manage one_auth configuration file
 * uabopennebula::conf::onedconf - Manage oned.conf file
 * uabopennebula::conf::vmmkvm - Manage vmm_exec/vmm_exec_kvm.conf file

## Naming conventions
 * All module specific variables should start with 'one_' prefix.

## Issues
 * Typically Puppet agent (on client side) runs as the 'root' user and hence you may experience failures while managing files located in NFS server with root squash enabled. The OpenNebula installation ($ONE_LOCATION) and OpenNebula system user's home directory are most likely to be located over NFS as well. So you will need to address this NFS issue if you want Puppet to manage NFS mounted files.

## Notes
Some of the module structure (parameterized classes and inheritance) is based on [puppetlabs/puppetlabs-opennebula](https://github.com/puppetlabs/puppetlabs-opennebula) module. However, there are some key differences with regards to instalation type and OS distro support. 
