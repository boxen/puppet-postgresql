# Public: Install and configure postgresql from homebrew.
#
# Examples
#
#   include postgresql
class postgresql(
  $ensure     = $postgresql::params::ensure,

  $executable = $postgresql::params::executable,

  $host       = $postgresql::params::host,
  $port       = $postgresql::params::port,
  $datadir    = $postgresql::params::datadir,
  $logdir     = $postgresql::params::logdir,

  $package    = $postgresql::params::package,
  $version    = $postgresql::params::version,

  $service    = $postgresql::params::service,
  $enable     = $postgresql::params::enable,

  $user       = $postgresql::params::user,
) inherits postgresql::params {

  class { 'postgresql::config':
    ensure     => $ensure,

    executable => $executable,

    host       => $host,
    port       => $port,
    datadir    => $datadir,
    logdir     => $logdir,

    notify     => Service['postgresql'],
  }

  ~>
  class { 'postgresql::package':
    ensure  => $ensure,

    package => $package,
    version => $version,
  }

  ~>
  class { 'postgresql::service':
    ensure  => $ensure,

    service => $service,
    enable  => $enable,

    datadir => $datadir,
    host    => $host,
    port    => $port,
  }

  ->
  Postgresql::Db <| |>

}
