require 'spec_helper'

describe 'postgresql' do
  let(:facts) { default_test_facts }

  it do
    should contain_class("postgresql::config")
    should contain_class("postgresql::package")
    should contain_class("postgresql::service")
  end
end
