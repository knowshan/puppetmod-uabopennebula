# required for xml parsing
require 'rexml/document'

# TODO: add instances class method for listing resources with ralsh/resource

Puppet::Type.type(:onehost).provide(:onehost) do
  desc "onehost provider"

  commands :onehost => "onehost"

  def create
    onehost "create", resource[:name], resource[:im_mad], resource[:vmm_mad],
      resource[:tm_mad], resource[:vnm_mad]
  end

  def delete
    onehost "delete", resource[:name]
  end

  def enable
    onehost "enable", resource[:name]
  end

  def disable
    onehost "disable", resource[:name]
  end

  # required for enable/disable create/delete - puppet calls it internally
  def exists?
    self.class.onehost_list().include?(resource[:name])
  end

  def self.onehost_list
    xml = REXML::Document.new(`onehost list -x`)
    onehosts = []
    xml.elements.each("HOST_POOL/HOST/NAME") do |element|
      onehosts << element.text
    end
    onehosts
  end

end
