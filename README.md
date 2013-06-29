# PostgreSQL Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-postgresql.png?branch=master)](https://travis-ci.org/boxen/puppet-postgresql)

## Usage

```puppet
# install postgres and run the service
include postgresql

# do the above automatically, and create a db
postgresql::db { 'mydb': }
```

## Required Puppet Modules

* `boxen`
* `homebrew`
* `stdlib`
* `sysctl`
