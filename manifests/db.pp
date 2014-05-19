# Creates a new postgresql database.
#
# Usage:
#
#     postgresql::db { 'mydb': }
define postgresql::db (
  $ensure = present,
  $owner = undef
) {
  require postgresql

  $db_owner = $db_owner ? { undef => $postgresql::user, default => $owner }

  exec { "postgresql-db-${name}":
    command => join([
      'createdb',
      "-p${postgresql::port}",
      '-E UTF-8',
      "-O ${db_owner}",
      $name
    ], ' '),
    unless  => "psql -aA -p${postgresql::port} -t -l | cut -d \\| -f 1 | grep -w '${name}'"
  }
}
