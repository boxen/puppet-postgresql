# Creates a new postgresql role
#
# Usage:
#
#     postgresql::role { 'rolename': }
define postgres::role (
  $password_hash    = false,
  $createdb         = false,
  $createrole       = false,
  $login            = true,
  $inherit          = true,
  $superuser        = false,
  $replication      = false,
  $connection_limit = '-1',
  $username         = $name
) {
  require postgresql
  notify { "Creating user ${$username}": }

  exec { "postgresql-createuser-${name}":
    command => join([
    'createuser',
    "-p${postgresql::port}",
    $username
    ], ' '),
    unless  => "psql -aA -p${postgresql::port} -t -l | tail +2 | grep -w '${username}'"
  }
}
