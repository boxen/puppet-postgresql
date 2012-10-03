class postgresql::config {
  require boxen::config

  $executable = "${boxen::config::home}/homebrew/bin/postgres"
  $datadir    = "${boxen::config::datadir}/postgresql"
  $logdir     = "${boxen::config::logdir}/postgresql"
  $port       = 15432

  file { [$datadir, $logdir]:
    ensure  => directory
  }

  file { '/Library/LaunchDaemons/com.boxen.postgresql.plist':
    content => template('postgresql/com.boxen.postgresql.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.boxen.postgresql'],
    owner   => 'root'
  }
}
