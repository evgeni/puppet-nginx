define nginx::vhost_install (
  $root = '/var/www',
  $listen = undef,
  $altnames = '',
  $strictname = false,
  $forcehttps = false,
  $ssllisten = undef,
  $ssl_certificate = '',
  $ssl_certificate_key = '',
  ) {

  $servername = strip("${name} ${altnames}")

  file { "/etc/nginx/sites-available/${name}.conf":
    ensure  => present,
    path    => "/etc/nginx/sites-available/${name}.conf",
    content => template('nginx/vhost.conf.erb'),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { "/etc/nginx/sites-enabled/${name}.conf":
    ensure  => link,
    path    => "/etc/nginx/sites-enabled/${name}.conf",
    target  => "/etc/nginx/sites-available/${name}.conf",
    require => File["/etc/nginx/sites-available/${name}.conf"],
    notify  => Service['nginx'],
  }

}
