# required for xml parsing
require 'rexml/document'

Puppet::Type.type(:onehost).provide(:onehost) do
  desc "onehost provider for the onehost type"

  commands :onehost => "onehost"

  def create
    onehost "create", resource[:name], resource[:im_mad], resource[:vmm_mad],
      resource[:tm_mad], resource[:vnm_mad]

    # check activate enable/disable property
  end

  def delete
    onehost "delete", resource[:name]
  end

  # called for enable => true
  def activate
    onehost "enable", resource[:name]
  end

  # called for enable => false
  def deactivate
    onehost "disable", resource[:name]
  end

  def enable
    host = resource[:name]
    xml = REXML::Document.new(`onehost show -x #{host}`)
    # HOST_STATES=%w{INIT MONITORING MONITORED ERROR DISABLED}
    #               { 0       1          2       3      4    }
    # Obviously Puppet can control only states 0 and 4. And any state other than
    # 4 means host is enabled.
    state = xml.text('HOST/STATE')
    if state == '4'
      :false
    else
      :true
    end
  end

  def exists?
    self.class.onehost_list().include?(resource[:name])
  end

  def self.onehost_list
    xml = REXML::Document.new(`onehost list -x`)
    onehosts = []
    xml.elements.each('HOST_POOL/HOST/NAME') do |element|
      onehosts << element.text
    end
    onehosts
  end

  def self.instances
    instances = []
    onehost_list().each do |host|
      hash = {}
      hash[:provider] = self.name.to_s
      xml = REXML::Document.new(`onehost show -x #{host}`)
      xml.elements.each('HOST/NAME') { |element| hash[:name] = element.text}
      instances << new(hash)
    end
    instances
  end

end
