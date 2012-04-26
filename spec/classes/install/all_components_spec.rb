require 'spec_helper'

describe 'uabopennebula::install::all_components' do

  context 'with default parameter values' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.7'}}

    # Test one_install_script
    it 'should contain executable install script' do
        should contain_file('/tmp/one_install_script').with({
          'mode'    => '0700',
          'content' => /\#!\/bin\/bash/,
        })
    end

    # Test if one_install_script execution is called after related File resource
    it 'should exec one_install script' do
      should contain_exec('/tmp/one_install_script').with({
        'require'  => 'File[/tmp/one_install_script]',
        'provider' => 'shell',
        'onlyif'   => "[[ ( -z \"$(/bin/ls -A /home/pavgi/tmp-install/cloud/one)\" ) || ('false' == 'true') ]]"
      })
    end

    # Test relationship with degems class
    it 'should include degems class' do
      should include_class 'uabopennebula::install::all_components_degems'
    end

  end # End-Of context default params

  context 'with custom one_install_script path' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.7'}}
    let (:params) {{:one_install_script => '/tmp/tmp_one_install_script.sh'}}
    # Test one_install_script
    it 'should contain executable install script' do
        should contain_file('/tmp/tmp_one_install_script.sh').with({
          'mode'    => '0700',
          'content' => /\#!\/bin\/bash/,
        })
    end
  end # End-Of context custom one_install_script path

  
end
