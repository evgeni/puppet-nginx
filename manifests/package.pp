# == Class: nginx::package
#
# Installs the NGINX webserver.
#
# === Authors
#
# Evgeni Golov <evgeni@golov.de>
#
# === Copyright
#
# Copyright 2013 Evgeni Golov
#
class nginx::package (
  $ensure = hiera('ensure', $nginx::params::ensure),
) inherits nginx::params {
  package { 'nginx':
    ensure => $ensure,
  }
}
