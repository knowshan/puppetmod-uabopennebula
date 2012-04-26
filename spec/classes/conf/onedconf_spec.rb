require 'spec_helper'

# A very basic test to get started with rspec
describe 'uabopennebula::conf::onedconf', :type => :class do

  # Test with default parameters
  context 'with default parameter values' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.7'}}
    it do
      # onedconf class should contain a file with following params
      # name/path: '/home/pavgi/tmp-install/cloud/one/etc/oned.conf'
      # mode: 0640
      # content: matched using RegEx as the Puppet manifest uses template function
      should contain_file('/home/pavgi/tmp-install/cloud/one/etc/oned.conf').with({
        'mode'     => '0640',
        'content'  => /OpenNebula Configuration file/,
        'owner'    => 'pavgi',
        'group'    => 'pavgi',
      })
      # should contain_file('/home/pavgi/tmp-install/cloud/one/etc/oned.conf').with_content(/OpenNebula Configuration file.*DB = [backend = sqlite3]/)
    end
  end

  # Test by changing one_oned_conf_path
  context 'with one_oned_conf_path => /srv/cloud/one/etc/oned.conf' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.7'}}
    let (:params) {{:one_oned_conf_path => '/srv/cloud/one/etc/oned.conf', :one_user => 'mickey', :one_group => 'mouse'}}
    it do
      should contain_file('/srv/cloud/one/etc/oned.conf').with({
        'mode'     => '0640',
        'content'  => /OpenNebula Configuration file/,
        'owner'    => 'mickey',
        'group'    => 'mouse',
      })
    end
  end
end
