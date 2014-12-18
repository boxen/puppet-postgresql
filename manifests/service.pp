# Internal: manages postgresql service
class postgresql::service(
  $ensure  = $postgresql::params::ensure,

  $service = $postgresql::params::service,
  $enable  = $postgresql::params::enable,

  $bindir  = $postgresql::params::bindir,
  $datadir = $postgresql::params::datadir,
  $host    = $postgresql::params::host,
  $port    = $postgresql::params::port,
) inherits postgresql::params {

  $svc_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  $nc = "nc -z ${host} ${port}"
  $pidfile = "${datadir}/postmaster.pid"

  if $::operatingsystem == 'Darwin' {
    service { 'com.boxen.postgresql':
      ensure => stopped,
      before => Service[$service],
      enable => false
    }
  }

  exec { 'init-postgresql-db':
    command => "${bindir}/initdb -E UTF-8 ${datadir}",
    creates => "${datadir}/PG_VERSION",
  }

  ->
  exec { 'kill-stale-postgres-pidfile':
    # Remove the pidfile, unless there's a postgres process running
    command => "rm -f ${pidfile}",
    unless  => "ps -p `head -1 ${pidfile}` | grep postgres",
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
