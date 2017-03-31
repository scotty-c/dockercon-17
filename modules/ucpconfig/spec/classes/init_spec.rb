require 'spec_helper'
describe 'ucpconfig' do

  context 'with defaults for all parameters' do
    it { should contain_class('ucpconfig') }
  end
end
