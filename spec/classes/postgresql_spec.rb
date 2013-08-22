require 'spec_helper'

describe 'postgresql' do
  let(:facts) { default_test_facts }

  it do
    should include_class('postgresql::config')
    should include_class('homebrew')
    should include_class('sysctl')

    ['data', 'log'].each do |dir|
      should contain_file("/test/boxen/#{dir}/postgresql").with({
        :ensure => 'directory',
      })
    end

    should contain_file('/Library/LaunchDaemons/dev.postgresql.plist').with({
      :content => File.read('spec/fixtures/dev.postgresql.plist'),
      :group   => 'wheel',
      :notify  => 'Service[dev.postgresql]',
      :owner   => 'root',
    })

    should contain_sysctl__set('kern.sysv.shmmax').with({
      :value => 1610612736
    })

    should contain_sysctl__set('kern.sysv.shmall').with({
      :value => 393216
    })

    should contain_homebrew__formula('postgresql').
      with_before('Package[boxen/brews/postgresql]')

    should contain_package('boxen/brews/postgresql').with({
      :ensure => '9.2.4-boxen2',
      :notify => 'Service[dev.postgresql]'
    })

    should contain_exec('init-postgresql-db').with({
      :command => 'initdb -E UTF-8 /test/boxen/data/postgresql',
      :creates => '/test/boxen/data/postgresql/PG_VERSION',
      :require => 'Package[boxen/brews/postgresql]'
    })

    should contain_service('dev.postgresql').with({
      :ensure  => 'running',
      :require => 'Exec[init-postgresql-db]'
    })

    should contain_service('com.boxen.postgresql').with({
      :ensure  => nil,
      :before => 'Service[dev.postgresql]'
    })

    should contain_file('/test/boxen/env.d/postgresql.sh').with({
      :content => File.read('spec/fixtures/postgresql.sh'),
      :require => 'File[/test/boxen/env.d]'
    })

    should contain_exec('wait-for-postgresql').with({
      :command  => 'while ! nc -z localhost 15432; do sleep 1; done',
      :provider => 'shell',
      :timeout  => 30,
      :unless   => 'nc -z localhost 15432',
      :require  => 'Service[dev.postgresql]'
    })
  end
end
