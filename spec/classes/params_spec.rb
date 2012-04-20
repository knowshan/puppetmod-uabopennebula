require 'spec_helper'

describe 'uabopennebula::params' do
  # See if code raises error for unsupported OS
  describe 'Check unsupported OS' do
    context 'with unsupported OS type' do
      let (:facts) {{:operatingsystem => 'entOS',:rubyversion => '1.8.7'}}
      it do
        expect { subject.should }.to raise_error(Puppet::Error)
      end
    end
  end
  # TODO: Add test for checking supported OS
end
