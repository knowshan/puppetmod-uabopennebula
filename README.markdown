# Puppet module for [OpenNebula](http://opennebula.org/)

### Not Maintained Anymore - Defunct

## Overview
This is a Puppet module for installing and managing self-contained [OpenNebula](http://opennebula.org/) installations. The module is being developed for self-contained directory installation of OpenNebula (3.0+) on CentOS and Ubuntu platforms. In addition to OpenNebula installation from source this module installs required Ruby gems dependencies and system packages as well. 

## Why another module?
The Puppet Labs module repository already contains an official [puppetlabs/ppennebula](https://github.com/puppetlabs/puppetlabs-opennebula) module. It works great and it has many OpenNebula commands already wrapped into Puppet DSL. However it supports only Debian OS and works  with relatively older version of OpenNebula (2.0.1). Since it didn't fit my OpenNebula installation requirements I decided to write a new module. Also I hadn't written any Puppet module before this so this looked like a good opportunity to get started with the Puppet as well.

## WARNING
I am a Puppet newbie and this is my first Puppet module. So there is a good scope for further improvements in this module. Don't complain but any suggestions or github issues are welcome! :)

## Examples

Install with a sqlite database backend:

    class { 'uabopennebula::install::all_components':
      one_version        => '3.4',
      one_install_type   => 'all',
      one_location       => '/srv/cloud/one',
      one_db_backend     => 'sqlite',
    }
	
Forced install with sqlite database backend. A forced install removes previous install in one_location:

    class { 'uabopennebula::install::all_components':
      one_version        => '3.4',
      one_install_type   => 'all',
      one_location       => '/srv/cloud/one',
      one_db_backend     => 'sqlite',
	  one_install_forced => 'true',
    }


Manage one_auth file for 'oneadmin' user:

    class { 'uabopennebula::conf::oneauth':
      one_oneadmin_password => 'password',
    }

Manage oned.conf file with defaults:

    class { 'uabopennebula::conf::onedconf': }
    

Manage oned.conf with custom database values:

    class { 'uabopennebula::conf::onedconf':
      one_db_backend  => 'mysql',
      one_db_host     => 'localhost',
      one_db_port     => '3306',
      one_db_user     => 'one',
      one_db_password => 'one',
      one_db_name     => 'onedb',
    }
	
Add hosts using onehost resource: 
    
	onehost{ 'kvm-02':
	  ensure => present,
	  enable => true,
	  im_mad => im_kvm,
	  vmm_mad => vmm_kvm,
	  tm_mad => tm_shared,
	  vnm_mad => dummy,
	}


## Module organization
The module classes are organized in three different namespaces according to their functionality. Following is a brief overview of each namespace or class-type. 
### install classes
The 'install' classes handle OpenNebula installation from source as well as installtion of dependency Ruby gems and system packages. The OpenNebula can be installed two ways - install all components together or  install only required component such as Sunstone web server, ozones etc. Right now this module supports 'all components' type install which will install all OpenNebula components in a self-contained directory location. I plan to add component specific installation classes later. 

OpenNebula source installation can be broken down in follwoing three steps:
 * Install system package dependencies (class: uabopennebula::install::all_components_depackages)
 * Install Ruby gems dependencies (class: uabopennebula::install::all_components_degems)
 * Compile and install OpenNebula from source (class: uabopennebula::install::all_components)
 
The module has defined a 'require' relationship with these three steps/classes. The source installation class requires Ruby gems class before proceeding with the install. The Ruby gems class in turn requires system packages class before installing Ruby gems. So if source installation class (uabopennebula::install::all_components) is called directly then it should handle Ruby gems and system packages installation as well.

The source installation class accepts a parameter called 'one_install_forced' which is set to value 'false' by default. By default the install class won't run an installation script if one_location directory is non-empty. However if 'one_install_forced' parameter is set to 'true' then the installation script will be run regardless of one_location state. The installtion script removes all files in the one_location directory before proceeding with the install.

### conf classes
The conf namespace contains parameterized classes to manage OpenNebula configuration files in $ONE_LOCATION/etc. Right now there is a separate class for each configuration file however it may change in later revisions. 

Note, the configuration classes do NOT check for existence of OpenNebula installation before applying their manifest. This is done intentionally so that users can use this module only for managing configuration files without having to run install step. Since Puppet supports 'run stages' it's possible to define 'require/before' relationship between classes outside of the module to run 'install'  classes befor 'conf' classes. 

### run or service classes
The run or service classes manage service 'resource' for the OpenNebula related processes - one daemon, sunstone server process. If any change in configuration files ('conf' classes) requires a restart or refresh of the related process then that class notifies (should 'notify'!) the related service resource. 


Any suggestions to change or improve this module organization are welcome. 

## Status
* Still under development
* Test System: CentOS 6.2, Ruby 1.8.7 and Puppet 2.6.12 
* Partially tested on Ubuntu 10.04 system 

## Requirements
 * [Puppet stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib) in Puppet module path

## Issues
 * Typically a Puppet agent (on client side) runs as the 'root' user and hence you may experience failures while managing files located in NFS server with root squash enabled. The OpenNebula installation ($ONE_LOCATION) and OpenNebula system user's home directory are most likely to be located over NFS as well. So you will need to address this NFS issue if you want Puppet to manage NFS mounted files.
