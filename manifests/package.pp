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
  $use_backport = hiera('use_backport', $nginx::params::use_backport),
) inherits nginx::params {
  if $use_backport {
    file { '/etc/apt/preferences.d/nginx.pref':
      ensure  => $ensure,
      content => template('nginx/etc/apt/preferences.d/nginx.pref.erb'),
    }
  } else {
    file { '/etc/apt/preferences.d/nginx.pref':
      ensure  => absent,
    }
  }

  package { 'nginx':
    ensure => $ensure,
    require => File['/etc/apt/preferences.d/nginx.pref'],
  }
}
