# = Class: uabopennebula::conf::onedconf
#
# Manage oned.conf file permissions and contents by modifying oned_conf.erb
# template file using configuration parameters passed to this class.
#
# == Parameters:
#
# * Parameter          Description (default)
# * $one_oned_conf_path:   Path to main OpenNebula configuration file oned.conf ($one_location/etc/oned.conf)
# * $one_db_backend:   Database backend type - sqlite or mysql (sqlite)
# * $one_db_host: -  - Database hostname ('undef')
# * $one_db_port: -  - Database port('undef')
# * $one_db_user: -  - Database username ('undef')
# * $one_db_password:  Plain text database password string ('undef')
#
# == Facts:
#
# * None
#
# == Actions:
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::conf::onedconf (
  # Config file path
  $one_oned_conf_path = "$uabopennebula::params::oned_conf_path",
  # Database parameters
  $one_db_backend = 'sqlite',
  $one_db_host = undef,
  $one_db_port = undef,
  $one_db_user = undef,
  $one_db_password = undef,
  $one_db_name = undef
  # VNC base port
  # XMLRPC port
  # Monitoring/polling intervals
  # Image repository, Host (hypervisor), VM monitoring drivers
) inherits uabopennebula::params {
  file { $one_oned_conf_path :
    content => template('uabopennebula/oned_conf.erb'),
    mode    => "0640",
  }
}

