class postgresql {
  require postgresql::config
  require sysctl

  sysctl::set { 'kern.sysv.shmmax':
    value => 1610612736
  }

  sysctl::set { 'kern.sysv.shmall':
    value => 393216
  }

  package { 'github/brews/postgresql':
    ensure => '9.1.4-github2',
    notify => Service['com.github.postgresql']
  }

  exec { 'init-postgresql-db':
    command => "initdb -E UTF-8 ${postgresql::config::datadir}",
    creates => "${postgresql::config::datadir}/PG_VERSION",
    require => Package['github/brews/postgresql']
  }

  service { 'com.github.postgresql':
    ensure  => running,
    require => Exec['init-postgresql-db']
  }

  file { "${github::config::envdir}/postgresql.sh":
    content => template('postgresql/env.sh.erb'),
    require => File[$github::config::envdir]
  }

  $nc = "nc -z localhost ${postgresql::config::port}"

  exec { 'wait-for-postgresql':
    command  => "while ! ${nc}; do sleep 1; done",
    provider => shell,
    timeout  => 30,
    unless   => $nc,
    require  => Service['com.github.postgresql']
  }
}
