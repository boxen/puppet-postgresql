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
      "${postgresql::bindir}/createdb",
      "-p${postgresql::port}",
      '-E UTF-8',
      "-O ${postgresql::user}",
      $name
    ], ' '),
    unless  => "${postgresql::bindir}/psql -a -p${postgresql::port} -t -l | cut -d \\| -f 1 | grep -w '${name}'"
  }
}
