# Creates a new postgresql role
#
# Usage:
#
#     postgresql::role { 'rolename': }
define postgresql::role (
  $ensure           = present,
  $username         = $name,
  $password         = undef,
  $createdb         = false,
  $createrole       = false,
  $login            = true,
  $inherit          = true,
  $superuser        = false,
  $replication      = false,
  $connection_limit = '-1',
) {
  require postgresql

  $createdb_sql    = $createdb    ? { true => 'CREATEDB',    default => 'NOCREATEDB' }
  $createrole_sql  = $createrole  ? { true => 'CREATEROLE',  default => 'NOCREATEROLE' }
  $login_sql       = $login       ? { true => 'LOGIN',       default => 'NOLOGIN' }
  $inherit_sql     = $inherit     ? { true => 'INHERIT',     default => 'NOINHERIT' }
  $superuser_sql   = $superuser   ? { true => 'SUPERUSER',   default => 'NOSUPERUSER' }
  $replication_sql = $replication ? { true => 'REPLICATION', default => '' }

  if ($password != undef) {
    $password_sql = "ENCRYPTED PASSWORD '${password}'"
  } else {
    $password_sql = ''
  }

  exec { "postgresql-createuser-${name}":
    command => join([
      'psql',
      "-p${postgresql::port}",
      "-c \"CREATE ROLE \"${username}\" ${password_sql} ${login_sql} ${createrole_sql} ${createdb_sql} ${superuser_sql} ${replication_sql} CONNECTION LIMIT ${connection_limit}\""
    ], ' '),
    unless  => "psql -aA -p${postgresql::port} -t -c \"SELECT rolname FROM pg_roles WHERE rolname='${username}'\" | tail +2 | grep ${username}"
  }
}
