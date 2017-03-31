require 'spec_helper'
describe 'swarmconfig' do
  context 'with default values for all parameters' do
    it { should contain_class('swarmconfig') }
  end
end
