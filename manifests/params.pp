# Internal: defaults
class postgresql::params {

  case $::operatingsystem {
    Darwin: {
      include boxen::config

      $bindir     = "${boxen::config::homebrewdir}/bin"
      $executable = "${bindir}/postgres"
      $datadir    = "${boxen::config::datadir}/postgresql-9.3"
      $logdir     = "${boxen::config::logdir}/postgresql-9.3"
      $port       = 15432

      $package    = 'boxen/brews/postgresql'
      $version    = '9.3.2-boxen'

      $service    = 'dev.postgresql'

      $user       = $::boxen_user
    }

    Ubuntu: {
      $executable = undef # only used on Darwin
      $bindir     = '/usr/bin'
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
