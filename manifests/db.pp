# Creates a new postgresql database.
#
# Usage:
#
#     postgresql::db { 'mydb': }
define postgresql::db(
  $ensure = present
) {
  require postgresql

  exec { "postgresql-db-${name}":
    command => join([
      'createdb',
      "-p${postgresql::port}",
      '-E UTF-8',
      "-O ${postgresql::user}",
      $name
    ], ' '),
    unless  => "psql -aA -p${postgresql::port} -t -l | cut -d \\| -f 1 | grep -w '${name}'"
  }
}
