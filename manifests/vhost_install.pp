define nginx::vhost_install ($config) {
  $altnames = $config[$name]['altnames']
  $strictname = $config[$name]['strictname']
  $forcehttps = $config[$name]['forcehttps']
  $root = $config[$name]['root']
  $listen = $config[$name]['listen']
  $ssllisten = $config[$name]['ssllisten']
  $ssl_certificate = $config[$name]['ssl_certificate']
  $ssl_certificate_key = $config[$name]['ssl_certificate_key']

  $servername = strip("${name} ${altnames}")

  file { "/etc/nginx/sites-available/${name}.conf":
    path    => "/etc/nginx/sites-available/${name}.conf",
    content => template('nginx/vhost.conf.erb'), 
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { "/etc/nginx/sites-enabled/${name}.conf":
    path    => "/etc/nginx/sites-enabled/${name}.conf",
    target  => "/etc/nginx/sites-available/${name}.conf",
    ensure  => link,
    require => File["/etc/nginx/sites-available/${name}.conf"],
    notify  => Service['nginx'],
  }

}
