require 'spec_helper'

# Test if Puppet::Error is returned for unsupported OS
describe 'uabopennebula::params' do
  # See if code raises error for unsupported OS
  describe 'Check unsupported OS' do
    context 'with OS as entOS' do
      let (:facts) {{:operatingsystem => 'entOS',:rubyversion => '1.8.7'}}
      it 'should return Puppet::Error from validate_re' do
        expect { subject.should }.to raise_error(Puppet::Error)
      end
    end
  end
  # TODO: Add test for checking supported OS
end
