# Puppet module for [OpenNebula](http://opennebula.org/)

## Overview
This is a Puppet module for installing and managing self-contained [OpenNebula](http://opennebula.org/) installations. I am developing this module primarily to support installation of newer versions of OpenNebula (3.0+) in a self-contained directory location. In addition to OpenNebula installation from source this module installs required Ruby gems dependencies and system packages as well.

## Why another module?
There already exists an official [puppetlabs module for OpenNebula](https://github.com/puppetlabs/puppetlabs-opennebula). It works great and it has many OpenNebula commands already wrapped into Puppet DSL. However it supports only Debian OS and works  with relatively older version of OpenNebula (2.0.1). Since it didn't fit my OpenNebula installation requirements I decided to write a new module. Also I hadn't written any Puppet module before this so this looked like a good start with Puppet as well.

## WARNING
I am a Puppet newbie and this is my first Puppet module. So it is likely to contain some mistakes or poor design choices. Don't complain but github issues and suggestions are welcome - you have been warned! :)

## Examples

Install with a sqlite database backend:

    class {"uabopennebula::install::all_components"
      one_version        => '3.4',
      one_install_type   => 'all',
      one_location       => '/srv/cloud/one',
      one_db_backend     => 'sqlite',
    }
	
Forced install with sqlite database backend. A forced install removes previous install in one_location:

    class {"uabopennebula::install::all_components"
      one_version        => '3.4',
      one_install_type   => 'all',
      one_location       => '/srv/cloud/one',
      one_db_backend     => 'sqlite',
	  one_install_forced => 'true',
    }


Manage one_auth file for 'oneadmin' user:

    class { "uabopennebula::conf::oneauth":
      one_oneadmin_password => "password",
    }

Manage oned.conf file with defaults:

    class {"uabopennebula::conf::onedconf": }
    

Manage oned.conf with custom database values:

    class {"uabopennebula::conf::onedconf":
      one_db_backend  => 'mysql',
      one_db_host     => 'localhost',
      one_db_port     => '3306',
      one_db_user     => 'one',
      one_db_password => 'one',
      one_db_name     => 'onedb',
    }


## Module organization
The module classes are organized in three different namespaces according to their functionality. Following is a brief overview of each namespace or class-type. 
### install classes
The 'install' classes handle OpenNebula installation from source as well as installtion of dependency Ruby gems and system packages. The OpenNebula can be installed two ways - install all components together or  install only required component such as Sunstone web server, ozones etc. Right now this module supports 'all components' type of install which will install all OpenNebula components in a self-contained directory location. I plan to add component specific installation classes later. 

OpenNebula source installation can be broken down in follwoing three steps:
 * Install system package dependencies (e.g. uabopennebula::install::all_components_depackages)
 * Install Ruby gems dependencies (e.g. uabopennebula::install::all_components_degems)
 * Compile and install OpenNebula from source (e.g. uabopennebula::install::all_components)
 
The module has defined a 'require' relationship with these three steps/classes. The source installation class (uabopennebula::install::all_components) requires Ruby gems class (uabopennebula::install::all_components_degems) before proceeding with the install. The Ruby gems class in turn requires system packages class (uabopennebula::install::all_components_depackages) before installing Ruby gems. So if you call source installation class (uabopennebula::install::all_components) directly then it should handle installation of Ruby gems and system packages as well.

The source installation class (uabopennebula::install::all_components) accepts a parameter called 'one_install_forced' which is set to value 'false' by default. By default install class won't run installation script if one_location directory is non-empty. However if 'one_install_forced' parameter is set to 'true' then install script will remove all the files in one_location directory and then perform OpenNebula source install.

### conf classes
The conf namespace contains parameterized classes to manage OpenNebula configuration files in $ONE_LOCATION/etc. Right now there is a separate class for each configuration file however it may change in later revisions. 

Note, that configuration classes do not check for existence of OpenNebula installation before applying their manifest. This is done intentionally so that users can use this module only for managing configuration files as well. Since Puppet supports 'run stages' it's possible to define 'require/before' relationship between classes outside of a module if anyone wants to manage both installation and configuration in an ordered sequence. 

### run or service classes
The run or service classes manage service 'resource' for the OpenNebula related processes - one daemon, sunstone server process. If any change in configuration files ('conf' classes) requires a restart or refresh of the related process then it should 'notify' service resource managing that process. 


Any suggestions to change or improve this module organization are welcome. 

## Status
* Still under development
* Test System: CentOS 6.2, Ruby 1.8.7 and Puppet 2.6.12 
* Partially tested on Ubuntu 10.04 system 


## Issues
 * Typically a Puppet agent (on client side) runs as the 'root' user and hence you may experience failures while managing files located in NFS server with root squash enabled. The OpenNebula installation ($ONE_LOCATION) and OpenNebula system user's home directory are most likely to be located over NFS as well. So you will need to address this NFS issue if you want Puppet to manage NFS mounted files.