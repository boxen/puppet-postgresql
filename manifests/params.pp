# Internal: defaults
class postgresql::params {

  case $::operatingsystem {
    Darwin: {
      include boxen::config

      $executable = "${boxen::config::home}/homebrew/bin/postgres"
      $datadir    = "${boxen::config::datadir}/postgresql"
      $logdir     = "${boxen::config::logdir}/postgresql"
      $port       = 15432

      $package    = 'boxen/brews/postgresql'
      $version    = '9.2.4-boxen2'

      $service    = 'dev.postgresql'

      $user       = $::boxen_user
    }

    Ubuntu: {
      $executable = undef # only used on Darwin
      $datadir    = '/var/lib/postgresql'
      $logdir     = '/var/log/postgresql'
      $port       = 5432

      $package    = 'postgresql-server-9.1'
      $version    = installed

      $service    = 'postgresql-9.1'

      $user       = 'postgresql'
    }

    default: {
      fail('Unsupported operating system!')
    }
  }

  $ensure = present
  $host   = $::ipaddress_lo0
  $enable = true

}
