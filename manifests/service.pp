# Internal: manages postgresql service
class postgresql::service(
  $ensure  = $postgresql::params::ensure,

  $service = $postgresql::params::service,
  $enable  = $postgresql::params::enable,

  $datadir = $postgresql::params::datadir,
  $host    = $postgresql::params::host,
  $port    = $postgresql::params::port,
) inherits postgresql::params {

  $svc_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  $nc = "nc -z ${host} ${port}"

  if $::operatingsystem == 'Darwin' {
    service { 'com.boxen.postgresql':
      ensure => stopped,
      before => Service[$service],
      enable => false
    }
  }

  exec { 'init-postgresql-db':
    command => "initdb -E UTF-8 ${datadir}",
    creates => "${datadir}/PG_VERSION",
  }

  ->
  service { $service:
    ensure => $svc_ensure,
    enable => $enable,
    alias  => 'postgresql',
  }

  ->
  exec { 'wait-for-postgresql':
    command  => "while ! ${nc}; do sleep 1; done",
    provider => shell,
    timeout  => 30,
    unless   => $nc,
  }

}
