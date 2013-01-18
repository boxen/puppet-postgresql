class postgresql::config {
  require boxen::config

  $executable = "${boxen::config::home}/homebrew/bin/postgres"
  $datadir    = "${boxen::config::datadir}/postgresql"
  $logdir     = "${boxen::config::logdir}/postgresql"
  $port       = 15432

  file { [$datadir, $logdir]:
    ensure  => directory
  }

  file { '/Library/LaunchDaemons/dev.postgresql.plist':
    content => template('postgresql/dev.postgresql.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.postgresql'],
    owner   => 'root'
  }
}
