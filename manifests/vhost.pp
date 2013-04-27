# define: nginx::vhost
#
# This definition creates a virtual host
#
# Parameters:
#   [*root*]                - Path to the files
#   [*listen*]              - Array of 'IP:port' or 'port' where to listen
#                             NGINX will listen on port 80 on all IPv4 interfaces if empty
#   [*altnames*]            - Alternative names this VHost should match (string or array)
#   [*strictname*]          - Redirect requests for altnames to the main host (true|false)
#   [*forcehttps*]          - Redirect HTTP to HTTPS (true|false)
#   [*ssllisten*]           - Array of IP:Port or Port where to listen with SSL enabled
#   [*ssl_certificate*]     - Path to the SSL certificate
#   [*ssl_certificate_key*] - Path to the SSL private key
#
# Sample Usage:
#  nginx::vhost { 'example.org':
#    root => '/srv/www/example.org',
#    altnames => ['www.example.org'],
#  }

define nginx::vhost (
  $root = '/var/www',
  $listen = undef,
  $altnames = '',
  $strictname = false,
  $forcehttps = false,
  $ssllisten = undef,
  $ssl_certificate = '',
  $ssl_certificate_key = '',
  $priority = 10,
  $locations = {},
  $proxy_pass = undef,
  $proxy_cache = undef,
  ) {

  if is_array($altnames) {
    $altnames_string = join($altnames, ' ')
  } else {
    $altnames_string = $altnames
  }
  $servername = strip("${name} ${altnames_string}")

  if $proxy_pass {
    $proxylocation = {'/' => {
                           proxy_pass => $proxy_pass,
                           proxy_cache => $proxy_cache,
                           include => '/etc/nginx/proxy_params',
                         }
                     }
    $all_locations = merge($proxylocation, $locations)
  } else {
    $all_locations = $locations
  }

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

  file { "/etc/nginx/sites-enabled/${priority}-${name}.conf":
    ensure  => link,
    path    => "/etc/nginx/sites-enabled/${priority}-${name}.conf",
    target  => "/etc/nginx/sites-available/${name}.conf",
    require => File["/etc/nginx/sites-available/${name}.conf"],
    notify  => Service['nginx'],
  }

}
