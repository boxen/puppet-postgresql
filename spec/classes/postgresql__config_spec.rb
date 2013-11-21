require 'spec_helper'

describe 'postgresql::config' do
  let(:facts) { default_test_facts }

  it do
    should include_class('boxen::config')

    %w(data/postgresql log/postgresql).each do |d|
      should contain_file("/test/boxen/#{d}").with_ensure(:directory)
    end

    contain_sysctl__set("kern.sysv.shmmax")
    contain_sysctl__set("kern.sysv.shmall")

    should include_class("boxen::config")
    should contain_boxen__env_script("postgresql")
    should contain_file("/Library/LaunchDaemons/dev.postgresql.plist")
  end

  context "Ubuntu" do
    let(:facts) { default_test_facts.merge(:operatingsystem => "Ubuntu") }

    it do
      should_not include_class("boxen::config")

      should_not contain_boxen__env_script("postgresql")
      should_not contain_file("/Library/LaunchDaemons/dev.postgresql.plist")
    end
  end
end
