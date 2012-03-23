# = Class: uabopennebula::conf:vmmkvm
#
# Manage vmm_kvm driver configuration file.
#
# == Parameters:
#
# * Parameter            Description (default)
# * $one_user: -  -  -   OpenNebula system user account (pavgi)
# * $one_group: -  -  -  OpenNebula system group account (pavgi)
# * $one_location:       OpenNebula install location ($oneadmin_home/tmp-install/cloud/one)
# * $one_vmm_kvm_conf:   Path to OpenNebula's KVM driver configuration file ($one_location/etc/vmm_exec/vmm_exec_kvm.conf)
# * $one_kvm_exec_path:  Path of KVM executable file on hypervisor hosts (/usr/libexec/qemu-kvm)
#
# == Facts:
#
# * None
#
# == Actions:
#
# == Author(s):
#   * Shantanu Pavgi, pavgi@uab.edu

class uabopennebula::conf::vmmkvm (
  # Primary parameters
  $one_location = "$uabopennebula::params::one_location",
  $one_user = "$uabopennebula::params::one_user",
  $one_group = "$uabopennebula::params::one_group",
  $one_vmm_kvm_conf = "${one_location}/etc/vmm_exec/vmm_exec_kvm.conf",
  $one_kvm_exec_path = "/usr/libexec/qemu-kvm"
  ) inherits uabopennebula::params {

  # Authentication file
  file { $one_vmm_kvm_conf :
    path     => $one_vmm_kvm_conf,
    content  => template('uabopennebula/one_vmm_kvm_conf.erb'),
    owner    => $one_user,
    group    => $one_group,
    mode     => "0640",
  }

}
