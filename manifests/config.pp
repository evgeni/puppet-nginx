# == Class: nginx::config
#
# Configures the NGINX webserver.
#
# === Authors
#
# Evgeni Golov <evgeni@golov.de>
#
# === Copyright
#
# Copyright 2013 Evgeni Golov
#
class nginx::config (
  $ensure             = hiera('ensure', $nginx::params::ensure),
  $user               = hiera('user', $nginx::params::user),
  $worker             = hiera('worker', $nginx::params::worker),
  $worker_connections = hiera('worker_connections', $nginx::params::worker_connections),
  $vhosts             = hiera('vhosts', {}),
) inherits nginx::params {

  file { '/etc/nginx/nginx.conf':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/nginx.conf.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/':
    ensure  => directory,
    path    => '/etc/nginx/sites-enabled/',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  file { '/etc/nginx/sites-available/':
    ensure  => directory,
    path    => '/etc/nginx/sites-available/',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  $k = keys($vhosts)
  nginx::config::generate_vhosts { $k: config => $vhosts; }

}
