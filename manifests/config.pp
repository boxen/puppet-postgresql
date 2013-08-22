# Internal: Configure postgresql.
#
# Examples
#
#   include postgresql::config
class postgresql::config {
  require boxen::config

  $executable = "${boxen::config::home}/homebrew/bin/postgres"
  $datadir    = "${boxen::config::datadir}/postgresql"
  $logdir     = "${boxen::config::logdir}/postgresql"
  $port       = 15432
}
