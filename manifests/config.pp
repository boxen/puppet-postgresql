# Internal: Manage configuration files for postgresql
class postgresql::config(
  $ensure     = $postgresql::params::ensure,

  $executable = $postgresql::params::executable,

  $host       = $postgresql::params::host,
  $port       = $postgresql::params::port,
  $datadir    = $postgresql::params::datadir,
  $logdir     = $postgresql::params::logdir,
) inherits postgresql::params {

  include sysctl

  $dir_ensure = $ensure ? {
    present => directory,
    default => absent,
  }

  file {
    [
      $datadir,
      $logdir
    ]:
      ensure => $dir_ensure;
  }

  sysctl::set {
    'kern.sysv.shmmax':
      value => 1610612736 ;
    'kern.sysv.shmall':
      value => 393216
  }

  if $::operatingsystem == 'Darwin' {
    include boxen::config

    boxen::env_script { 'postgresql':
      content  => template('postgresql/env.sh.erb'),
      priority => 'lower',
    }

    file { "${boxen::config::envdir}/postgresql.sh":
      ensure => absent,
    }


    file { '/Library/LaunchDaemons/dev.postgresql.plist':
      content => template('postgresql/dev.postgresql.plist.erb'),
      group   => 'wheel',
      owner   => 'root',
    }
  }
}
