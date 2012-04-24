require 'spec_helper'
# Test if important gem dependencies are included in the manifest
# Not testing all the gems; would be tedious task to write it
# and hence skipping it for now!

describe 'uabopennebula::install::all_components_degems' do

  # CentOS and Ruby 1.9.2
  context 'check Ruby gems with CentOS operatingsystem and Ruby 1.9.2' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.9.2'}}
    it 'should ensure uuidtools gem is installed' do
        should contain_package('uuidtools').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure xmlparser gem is installed' do
        should contain_package('nokogiri').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure sinatra gem is installed' do
        should contain_package('sinatra').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
  end
  # CentOS and Ruby 1.8.7
  context 'check Ruby gems with CentOS operatingsystem and Ruby 1.8.7' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.7'}}
    it 'should ensure uuidtools gem is installed' do
        should contain_package('uuidtools').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure xmlparser gem is installed' do
        should contain_package('xmlparser').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure sinatra gem is installed' do
        should contain_package('sinatra').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure sqlite3 gem 1.2.0 is installed' do
        should contain_package('sqlite3').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
  end # EndContext CentOS

  # CentOS and Ruby 1.8.5
  context 'check Ruby gems with CentOS operatingsystem and Ruby 1.8.5' do
    let (:facts) {{:operatingsystem => 'CentOS',:rubyversion => '1.8.5'}}
    it 'should ensure uuidtools gem is installed' do
        should contain_package('uuidtools').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure sqlite3-ruby gem 1.2.0 is installed' do
        should contain_package('sqlite3-ruby').with({
          'provider'   => 'gem',
          'ensure'     => '1.2.0',
        })
    end
  end # EndContext CentOS; Ruby 1.8.5

  # Ubuntu OS; Ruby 1.8.7
  context 'check Ruby gems with Ubuntu operatingsystem and Ruby 1.8.7' do
    let (:facts) {{:operatingsystem => 'Ubuntu',:rubyversion => '1.8.7'}}
    it 'should ensure uuidtools gem is installed' do
        should contain_package('uuidtools').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
    it 'should ensure sinatra gem is installed' do
        should contain_package('sinatra').with({
          'provider'   => 'gem',
          'ensure'     => 'installed',
        })
    end
  end # EndContext Ubuntu; Ruby 1.8.7
end
