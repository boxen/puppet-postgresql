# Creates a new postgresql database.
#
# Usage:
#
#     postgresql::db { 'mydb': }
define postgresql::db($ensure = present) {
  require postgresql

  exec { "postgresql-db-${name}":
    command => join([
      'createdb',
      "-p${postgresql::config::port}",
      '-E UTF-8',
      "-O ${::boxen_user}",
      $name
    ], ' '),
    require => Exec['wait-for-postgresql'],
    unless  => "psql -aA -p${postgresql::config::port} -t -l | cut -d \\| -f 1 | grep -w '${name}'"
  }
}
