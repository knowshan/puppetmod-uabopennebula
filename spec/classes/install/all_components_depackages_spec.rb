require 'spec_helper'
# Test if important packages are included in the manifest
# Not testing all the packages; would be tedious task to write it
# and hence skipping it for now!

describe 'uabopennebula::install::all_components_depackages' do
  context 'check package names with CentOS operatingsystem' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.7'}}
    it 'should ensure gcc-c++ package is installed' do
        should contain_package('gcc-c++').with({
          'ensure'     => 'installed',
        })
    end
    it 'should ensure ruby-devel package is installed' do
        should contain_package('ruby-devel').with({
          'ensure'     => 'installed',
        })
    end
    it 'should ensure cmake package is installed' do
        should contain_package('cmake').with({
          'ensure'     => 'installed',
        })
    end
    it 'should ensure scons package is installed' do
        should contain_package('scons').with({
          'ensure'     => 'installed',
        })
    end
  end # EndContext CentOS

  context 'check package names with Ubuntu operatingsystem' do
    let (:facts) {{:operatingsystem => 'Ubuntu',:rubyversion => '1.8.7'}}
    it 'should ensure build-essentials package is installed' do
        should contain_package('build-essential').with({
          'ensure'     => 'installed',
        })
    end
    it 'should ensure ruby-dev package is installed' do
        should contain_package('ruby-dev').with({
          'ensure'     => 'installed',
        })
    end
    it 'should ensure cmake package is installed' do
        should contain_package('cmake').with({
          'ensure'     => 'installed',
        })
    end
    it 'should ensure cmake package is installed' do
        should contain_package('scons').with({
          'ensure'     => 'installed',
        })
    end
  end # EndContext Ubuntu
end
