Puppet::Type.newtype(:onehost) do
  @doc = <<-EOS
Manage OpenNebula hosts (hypervisors) through Puppet using onehost command.
EOS

  ensurable do
    newvalue(:create) do
      provider.create
    end

    newvalue(:delete) do
      provider.destroy
    end

    newvalue(:enable)  do
      provider.enable
    end

    newvalue(:disable) do
      provider.disable
    end

    # defaultto :create
  end

  newparam(:name) do
    desc "Name of host."

    isnamevar
  end

  newparam(:im_mad) do
    desc "Information Driver"
  end

  newparam(:vmm_mad) do
    desc "Virtualization Driver"
  end

  newparam(:tm_mad) do
    desc "Transfer Driver"
  end

  newparam(:vnm_mad) do
    desc "Virtual Network Driver"
  end

end
