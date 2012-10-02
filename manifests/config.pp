class postgresql::config {
  require github::config

  $executable = "${github::config::home}/homebrew/bin/postgres"
  $datadir    = "${github::config::datadir}/postgresql"
  $logdir     = "${github::config::logdir}/postgresql"
  $port       = 15432

  file { [$datadir, $logdir]:
    ensure  => directory
  }

  file { '/Library/LaunchDaemons/com.github.postgresql.plist':
    content => template('postgresql/com.github.postgresql.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.github.postgresql'],
    owner   => 'root'
  }
}
