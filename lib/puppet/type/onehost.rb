Puppet::Type.newtype(:onehost) do
  desc "Manage OpenNebula hosts (hypervisors) through Puppet using onehost command."

# Resource Properties
  # ensurable - used for onehost create and delete
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.delete
    end
    # Add alias for values - same as corresponding onehost commands
    aliasvalue(:create,:present)
    aliasvalue(:delete,:absent)
    defaultto :present
  end #ensurable

  # enable true/false property for onehost enable and disable commands
  newproperty :enable do
    newvalue :true do
      provider.activate
    end

    newvalue :false do
      provider.deactivate
    end
  end # enable

# Resource Parameters
  # namevar parameter - hostname
  newparam(:name) do
    desc "Hypervisor hostname"
    isnamevar
  end

  newparam(:im_mad) do
    desc "Information Manager Driver"
  end

  newparam(:vmm_mad) do
    desc "Virtualization Manager Driver"
  end

  newparam(:tm_mad) do
    desc "Transfer Manager Driver"
  end

  newparam(:vnm_mad) do
    desc "Virtual Network Manager Driver"
  end

end
